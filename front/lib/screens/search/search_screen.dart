import 'package:flutter/material.dart';
import '../../models/search/local_search_result.dart';
import '../../services/search/local_search_service.dart';
import '../search/search_result_map.dart';
import 'package:gilin/widgets/route/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final LocalSearchService _searchService = LocalSearchService(
    clientId: 'v4kMJLqjdp4lbZVvGtGg',
    clientSecret: 'PzZBG3URHV',
  );
  List<LocalSearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // 인풋값이 변경될 때마다 검색
    _searchController.addListener(() {
      _performSearch(_searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      var results = await _searchService.searchLocal(query: query);

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });

      if (results.isEmpty) {
        setState(() {
          _error = '검색 결과가 없습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _error = '검색 중 오류가 발생했습니다: $e';
        _isLoading = false;
        _searchResults = [];
      });
    }
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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(child: Text(_error!))
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
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
            onSubmitted: (_) {},
            hintText: '장소를 검색해보세요',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
