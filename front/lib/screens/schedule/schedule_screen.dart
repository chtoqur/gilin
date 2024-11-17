import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/navigation/navigation_provider.dart';
import 'package:go_router/go_router.dart';

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
          ElevatedButton(
            onPressed: () => ref
                .read(bottomNavProvider.notifier)
                .navigateToPage(context, 0, '/my_route'),
            child: const Text('Go to My Route Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).updateIndex(3);
              context.push('/signup_step1');
            },
            child: const Text('Go to SignUp Page'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).updateIndex(3);
              context.push('/success');
            },
            child: const Text('Go to Success Page'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).updateIndex(3);
              context.push('/failure');
            },
            child: const Text('Go to Failure Page'),
          ),
        ],
      ),
    );
  }
}
