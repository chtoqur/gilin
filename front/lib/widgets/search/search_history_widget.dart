// SearchHistoryWidget
import 'package:flutter/material.dart';

class SearchHistoryWidget extends StatelessWidget {
  final List<String> savedLocations;
  final TextEditingController searchController;

  const SearchHistoryWidget({
    Key? key,
    required this.savedLocations,
    required this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: savedLocations.length,
      itemBuilder: (context, index) {
        bool showBorder = index > 0 && index < savedLocations.length - 1;
        return SearchHistoryItem(
          searchText: savedLocations[index],
          showBorder: showBorder,
          onTap: () {
            // 클릭 시 해당 검색어를 searchController에 설정
            searchController.text = savedLocations[index];
          },
        );
      },
    );
  }
}

class SearchHistoryItem extends StatelessWidget {
  final String searchText;
  final bool showBorder;
  final VoidCallback onTap;

  const SearchHistoryItem({
    Key? key,
    required this.searchText,
    this.showBorder = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: showBorder ? const Border(
            top: BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1.0,
            ),
          ) : null,
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                size: 25,
                color: Colors.black54,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  searchText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}