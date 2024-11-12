import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/navigation/navigation_provider.dart';

class MypageScreen extends ConsumerWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Schedule my page Screen'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref
                .read(bottomNavProvider.notifier)
                .navigateToPage(context, 0, '/login'),
            child: const Text('Go to Login'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref
                .read(bottomNavProvider.notifier)
                .navigateToPage(context, 3, '/signup'),
            child: const Text('Go to Signup'),
          ),
        ],
      ),
    );
  }
}