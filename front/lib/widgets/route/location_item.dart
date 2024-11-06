// widgets/location_item.dart
import 'package:flutter/material.dart';

class LocationItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const LocationItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.place, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
            TextButton(
              onPressed: () {},
              child: const Text('편집'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('삭제'),
            ),
          ],
        ),
      ),
    );
  }
}