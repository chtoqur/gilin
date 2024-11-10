import 'package:flutter/material.dart';
import '../../models/search/local_search_result.dart';

class SearchResultItem extends StatelessWidget {
  final LocalSearchResult result;

  const SearchResultItem({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.category,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),
            Text(
              '도로명: ${result.roadAddress}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '지번: ${result.address}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
