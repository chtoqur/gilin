import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Schedule Home Screen'),
          const SizedBox(height: 20), // 버튼과 텍스트 사이 간격
          ElevatedButton(
            onPressed: () => context.go('/route'), // go_router를 사용한 네비게이션
            child: const Text('Go to Route'),
          ),
          const SizedBox(height: 20), // 버튼과 텍스트 사이 간격
          ElevatedButton(
            onPressed: () => context.go('/test'), // go_router를 사용한 네비게이션
            child: const Text('Go to test Screen'),
          ),
        ],
      ),
    );
  }
}