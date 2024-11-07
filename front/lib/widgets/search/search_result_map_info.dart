import 'package:flutter/material.dart';
import '../../models/search/local_search_result.dart';

class SearchResultMapInfo extends StatelessWidget {
  final LocalSearchResult searchResult;
  final VoidCallback? onStartPressed;
  final VoidCallback? onEndPressed;

  const SearchResultMapInfo({
    Key? key,
    required this.searchResult,
    this.onStartPressed,
    this.onEndPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 장소 기본 정보
          Text(
            searchResult.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchResult.category,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            searchResult.roadAddress,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // 출발/도착 버튼
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onStartPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('출발'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onEndPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('도착'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}