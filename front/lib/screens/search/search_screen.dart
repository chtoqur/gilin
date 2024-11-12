import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gilin/screens/search/search_result_sheet.dart';
import 'package:gilin/widgets/route/main/saved_locations_widget.dart';
import 'package:gilin/widgets/search/search_history_widget.dart';
import '../../models/search/local_search_result.dart';
import '../../services/search/local_search_service.dart';
import '../search/search_result_map.dart';
import '../search/search_results_map.dart';
import 'package:gilin/widgets/route/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final LocalSearchService _searchService = LocalSearchService(
    apiKey: '4611747a9ec4e2703671ba7df3cb5ca9',
  );

  List<LocalSearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  int _currentPage = 1;
  static const int _itemsPerPage = 15;
  bool _hasMoreItems = true;
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
      _searchController.addListener(() {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          _resetSearch();
          _performSearch(_searchController.text);
        });
      });
      _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMoreItems) {
        _loadMoreItems();
        }
      }
    }

  // void _resetSearch() {
  //   _currentPage = 1;
  //   _hasMoreItems = true;
  //   _searchResults = [];
  // }

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

  // 지도로 이동하는 검색 메소드
  Future<void> _executeSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      var results = await _searchService.searchLocal(
        query: query,
        size: _itemsPerPage,
        page: 1,
      );

      if (results.isNotEmpty) {
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsMap(
                searchResults: results,
              ),
            ),
          );
        }
      } else {
        setState(() {
          _error = '검색 결과가 없습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _error = '검색 중 오류가 발생했습니다: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetSearch() {
    _currentPage = 1;
    _hasMoreItems = true;
    _searchResults = [];
  }

  final List<String> savedLocations = [
    "삼성전자",
    "멀티캠퍼스 역삼",
    "선릉역 2번 출구",
    "갤럭시"
  ]; // 추후 실제 데이터로 교체

  @override
  Widget build(BuildContext context) {
    bool hasSearchQuery = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 검색어가 없을 때: 기본 화면
          if (!hasSearchQuery)
            Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF8F5F0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(70),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: const SavedLocationsWidget(),
                        ),
                      ),
                      SearchHistoryWidget(
                        savedLocations: savedLocations,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          // 검색어가 있을 때: 검색 결과 화면 표시
          if (hasSearchQuery)
            Column(
              children: [
                const SizedBox(height: 70),
                Expanded(
                  child: _isLoading && _searchResults.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(child: Text(_error!))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _searchResults.length + (_hasMoreItems ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _searchResults.length) {
                              return Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              );
                            }

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResultMap(
                                      searchResult: _searchResults[index],
                                    ),
                                  ),
                                );
                              },
                              child: SearchResultSheet(
                                result: _searchResults[index],
                                searchQuery: _searchController.text,
                                showBorder: index > 0,  // 첫 번째 아이템은 border 없음
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

          CustomSearchBar(
            controller: _searchController,
            readOnly: false,
            isRouteScreen: true,
            onSubmitted: (query) => _executeSearch(query),
            hintText: '장소를 검색해보세요',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}