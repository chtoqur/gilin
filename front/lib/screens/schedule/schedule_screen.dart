import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/navigation/navigation_provider.dart';  // Riverpod import 추가

// StatelessWidget을 ConsumerWidget으로 변경
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // WidgetRef ref 추가
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Schedule Home Screen'),
          const SizedBox(height: 20),
          ElevatedButton(
            // 첫 번째 버튼도 navigateToPage로 변경
            onPressed: () => ref.read(bottomNavProvider.notifier).navigateToPage(
                context,
                0,  // route 화면의 인덱스
                '/route'
            ),
            child: const Text('Go to Route'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref.read(bottomNavProvider.notifier).navigateToPage(
                context,
                3,
                '/test'
            ),
            child: const Text('Go to test Screen'),
          ),
        ],
      ),
    );
  }
}