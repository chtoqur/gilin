import 'dart:async';

import 'package:flutter/material.dart';
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
          Navigator.push(
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
  @override
  Widget build(BuildContext context) {
    bool hasSearchQuery = _searchController.text.isNotEmpty;

    return Scaffold(
      body: Stack(
        children: [
          // 검색어가 없을 때: 기본 화면
          if (!hasSearchQuery)
            Container(
              padding: const EdgeInsets.only(top: 70),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 100, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('검색어를 입력해주세요',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              ),
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

                            var result = _searchResults[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(result.title),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(result.category),
                                    Text(result.roadAddress),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchResultMap(
                                        searchResult: result,
                                      ),
                                    ),
                                  );
                                },
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