import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/navigation/navigation_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Schedule Home Screen'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                ref.read(bottomNavProvider.notifier).navigateToPage(
                    context,
                    0, // route 화면의 인덱스
                    '/route'),
            child: const Text('Go to Route'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref
                .read(bottomNavProvider.notifier)
                .navigateToPage(context, 3, '/test'),
            child: const Text('Go to test Screen'),
          ),
        ],
      ),
    );
  }
}
