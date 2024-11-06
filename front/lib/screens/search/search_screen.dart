import 'package:flutter/material.dart';
import '../route/widgets/search_bar.dart';

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
      // appBar�� �����ϰ� body�� Stack���� ����
      body: Stack(
        children: [
          // �˻� ��� ����Ʈ
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60, // SearchBar ���� + ���� ���
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                // �˻� ��� �����۵�
              ],
            ),
          ),

          // SearchBar
          CustomSearchBar(
            controller: _searchController,
            readOnly: false,
            hintText: '��Ҹ� �˻��غ�����',
            onSubmitted: (value) {
              // �˻� ���� ����
              print('Searching for: $value');
            },
          ),

          // �ڷΰ��� ��ư (���û���)
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