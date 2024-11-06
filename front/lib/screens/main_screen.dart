import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/providers/navigation_provider.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  final Widget child;
  const MainScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      body: SafeArea(
        child: child,  // _screens[currentIndex] 대신 child 사용
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavProvider.notifier).setPage(index);
          switch (index) {  // index에 따라 경로 이동
            case 0:
              context.go('/route');
              break;
            case 1:
              context.go('/schedule');
              break;
            case 2:
              context.go('/alert');
              break;
            case 3:
              context.go('/mypage');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MY',
          ),
        ],
        selectedItemColor: const Color(0xfff4a700),
        unselectedItemColor: const Color(0xff3a3a3a),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}