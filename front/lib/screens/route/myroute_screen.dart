import 'package:flutter/material.dart';

class MyrouteScreen extends StatelessWidget {
  const MyrouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('내 경로 2'),
        const SizedBox(height: 12),
        RouteItem(
          from: '서울 강남구 테헤란로 201-2',
          to: '하계역 7호선',
        ),
        RouteItem(
          from: '강남역 2호선',
          to: '오목사',
        ),
      ],
    );
  }
}

class RouteItem extends StatelessWidget {
  final String from;
  final String to;

  const RouteItem({
    Key? key,
    required this.from,
    required this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.navigation, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(from),
                Text('→ $to', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}