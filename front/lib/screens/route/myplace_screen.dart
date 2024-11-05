// myplace_screen.dart
import 'package:flutter/material.dart';
import 'widgets/location_item.dart';

class MyplaceScreen extends StatelessWidget {
  const MyplaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('전체 목록 4'),
        const SizedBox(height: 12),
        LocationItem(
          title: '멀티캠퍼스 역삼',
          onTap: () {},
        ),
        LocationItem(
          title: '이사네',
          onTap: () {},
        ),
        LocationItem(
          title: '선릉역 2번 출구',
          onTap: () {},
        ),
        LocationItem(
          title: '본가',
          onTap: () {},
        ),
      ],
    );
  }
}