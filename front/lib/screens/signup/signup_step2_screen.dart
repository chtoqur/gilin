import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../models/search/local_search_result.dart';
import '../../services/search/local_search_service.dart';

class SignupStep2Screen extends StatefulWidget {
  const SignupStep2Screen({super.key});

  @override
  State<SignupStep2Screen> createState() => _SignupStep2ScreenState();
}

class _SignupStep2ScreenState extends State<SignupStep2Screen> {
  String selectedType = '집';
  double? selectedX;
  double? selectedY;
  String? selectedAddress;
  TimeOfDay? arrivalTime;

  final TextEditingController _searchController = TextEditingController();
  final LocalSearchService _searchService = LocalSearchService(apiKey: '4611747a9ec4e2703671ba7df3cb5ca9');

  List<LocalSearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  Timer? _debounce;
  int _currentPage = 1;
  static const int _itemsPerPage = 15;
  bool _hasMoreItems = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
    _scrollController.addListener(_scrollListener);
  }

  void _onSearchTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _resetSearch();
      _performSearch(_searchController.text);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasMoreItems) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_searchController.text.isEmpty) return;
    _currentPage++;
    await _performSearch(_searchController.text, isLoadingMore: true);
  }

  Future<void> _performSearch(String query, {bool isLoadingMore = false}) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = null;
      });
      return;
    }

    if (!isLoadingMore) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      var results = await _searchService.searchLocal(
        query: query,
        size: _itemsPerPage,
        page: _currentPage,
      );

      setState(() {
        if (isLoadingMore) {
          _searchResults.addAll(results);
        } else {
          _searchResults = results;
        }
        _isLoading = false;
        _hasMoreItems = results.length == _itemsPerPage;
      });

      if (_searchResults.isEmpty) {
        setState(() {
          _error = '검색 결과가 없습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _error = '검색 중 오류가 발생했습니다: $e';
        _isLoading = false;
        if (!isLoadingMore) {
          _searchResults = [];
        }
      });
    }
  }

  void _resetSearch() {
    _currentPage = 1;
    _hasMoreItems = true;
    _searchResults = [];
  }

  @override
  Widget build(BuildContext context) {
    bool hasSearchQuery = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '나만의 장소를 등록해보세요',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF463C33),
                      ),
                    ),
                    const Gap(15),
                    const Text(
                      '자주 가는 장소를 등록해 빠르게 길찾기를 시작하세요.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF74695E),
                      ),
                    ),
                    const Gap(30),

                    // 장소 타입 선택 버튼들
                    _buildPlaceTypeSelector(),

                    const Gap(20),

                    // 주소 입력란
                    _buildAddressField(),

                    const Gap(20),

                    // 도착 시간 설정
                    _buildArrivalTimePicker(context),

                    const Gap(20),

                    if (hasSearchQuery)
                      _isLoading && _searchResults.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                          ? Center(child: Text(_error!))
                          : ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: _searchResults.length + (_hasMoreItems ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _searchResults.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return ListTile(
                            title: Text(_searchResults[index].title),
                            subtitle: Text(_searchResults[index].address),
                            onTap: () {
                              setState(() {
                                selectedAddress = _searchResults[index].address;
                                selectedX = _searchResults[index].x;
                                selectedY = _searchResults[index].y;
                                _searchController.text = selectedAddress!;
                              });
                            },
                          );
                        },
                      ),

                    const Gap(30),

                    // 저장하기 버튼
                    _buildSaveButton(context),
                  ],
                ),
              ),
            ),

            // "다음에 할게요" 버튼
            _buildSkipButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceTypeSelector() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildTypeButton('집'),
          _buildTypeButton('회사'),
          _buildTypeButton('학교'),
          _buildTypeButton('기타'),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type) {
    bool isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = type),
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE4DBCF) : Colors.transparent,
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getIconForType(type), size: 16),
              const Gap(6),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '주소를 등록해주세요.',
            style: TextStyle(
              color: Color(0xFF777777),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF777777)),
            onPressed: () {
              // 주소 검색 로직 추가
              print('주소 검색 클릭');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArrivalTimePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '도착 시간',
          style: TextStyle(
            color: Color(0xFF3A3A3A),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF3A3A3A),
          ),
          onPressed: () async {
            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: arrivalTime ?? TimeOfDay.now(),
            );
            if (time != null) {
              setState(() => arrivalTime = time);
            }
          },
          child: Text(
            arrivalTime != null
                ? '${arrivalTime!.hour}:${arrivalTime!.minute.toString().padLeft(2, '0')}'
                : '시간 선택',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF8EAAB),
        foregroundColor: const Color(0xFF3A3A3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: _updatePlace,
      child: const Text(
        '저장하기',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      color: const Color(0xFF669358),
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/route');
        },
        child: const Text(
          '다음에 할게요',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case '집':
        return Icons.home;
      case '회사':
        return Icons.business;
      case '학교':
        return Icons.school;
      case '기타':
        return Icons.place;
      default:
        return Icons.help;
    }
  }

  Future<void> _updatePlace() async {
    if (selectedX == null || selectedY == null || selectedAddress == null || arrivalTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해 주세요.')),
      );
      return;
    }

    try {
      var token = await _getToken();
      if (token == null) throw Exception('유효한 토큰이 없습니다.');

      var dio = Dio(BaseOptions(
        baseUrl: 'https://k11a306.p.ssafy.io/api',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ));

      var response = await dio.put('/user/place', data: {
        'type': _getPlaceType(selectedType),
        'x': selectedX,
        'y': selectedY,
        'address': selectedAddress,
        'arrivalTime': {
          'hour': arrivalTime!.hour,
          'minute': arrivalTime!.minute,
          'second': 0,
          'nano': 0,
        },
      });

      if (response.statusCode == 200 && context.mounted) {
        await Navigator.pushReplacementNamed(context, '/route');
      }
    } catch (e) {
      print('장소 정보 업데이트 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('장소 정보 저장에 실패했습니다.')),
      );
    }
  }

  int _getPlaceType(String type) {
    switch (type) {
      case '집':
        return 1;
      case '회사':
        return 2;
      case '학교':
        return 3;
      case '기타':
        return 4;
      default:
        return 1;
    }
  }

  Future<String?> _getToken() async {
    try {
      var tokenInfo = await UserApi.instance.accessTokenInfo();
      return tokenInfo.id.toString();
    } catch (e) {
      print('토큰 정보를 가져오는 중 오류 발생: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
