import 'package:flutter/material.dart';
import 'package:gilin/widgets/route/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar를 제거하고 body를 Stack으로 변경
      body: Stack(
        children: [
          // 검색 결과 리스트
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60, // SearchBar 높이 + 여백 고려
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                // 검색 결과 아이템들
              ],
            ),
          ),

          // SearchBar
          CustomSearchBar(
            controller: _searchController,
            readOnly: false,
            hintText: '장소를 검색해보세요',
            onSubmitted: (value) {
              // 검색 로직 구현
              print('Searching for: $value');
            },
          ),

          // 뒤로가기 버튼 (선택사항)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}