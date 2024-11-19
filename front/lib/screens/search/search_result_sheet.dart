import 'package:flutter/material.dart';
import 'package:gilin/utils/route/format_category_utils.dart';

import '../../models/search/local_search_result.dart';

class SearchResultSheet extends StatelessWidget {
  final LocalSearchResult result;
  final String searchQuery;
  final bool showBorder;

  const SearchResultSheet({
    Key? key,
    required this.result,
    required this.searchQuery,
    this.showBorder = true,
  }) : super(key: key);

  // 검색어와 일치하는 부분을 하이라이트
  Widget _highlightedTitle(String title) {
    if (searchQuery.isEmpty) return Text(title);

    List<TextSpan> spans = [];
    int start = 0;
    String lowercaseTitle = title.toLowerCase();
    String lowercaseQuery = searchQuery.toLowerCase();

    while (start < title.length) {
      int indexOfQuery = lowercaseTitle.indexOf(lowercaseQuery, start);
      if (indexOfQuery == -1) {
        spans.add(TextSpan(text: title.substring(start)));
        break;
      }

      if (indexOfQuery > start) {
        spans.add(TextSpan(text: title.substring(start, indexOfQuery)));
      }

      spans.add(
        TextSpan(
          text:
              title.substring(indexOfQuery, indexOfQuery + searchQuery.length),
          style: TextStyle(
            backgroundColor:
                const Color(0xFFFFEB3B).withOpacity(0.3), // 노란색 하이라이트
            color: Colors.black,
          ),
        ),
      );

      start = indexOfQuery + searchQuery.length;
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                top: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1.0,
                ),
              )
            : null,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 30,
            color: Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _highlightedTitle(result.title),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      FormatCategoryUtils.formatCategory(
                          result.category), // 포맷된 카테고리 사용
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  result.roadAddress,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
