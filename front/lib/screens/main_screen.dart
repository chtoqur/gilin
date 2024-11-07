// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/navigation/navigation_provider.dart';

class MainScreen extends ConsumerWidget {
  final Widget child;
  final bool showBottomNav;

  const MainScreen({
    Key? key,
    required this.child,
    this.showBottomNav = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: showBottomNav ? BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          var routes = ['/route', '/schedule', '/alert', '/mypage'];
          ref.read(bottomNavProvider.notifier).navigateToPage(
            context,
            index,
            routes[index],
          );
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
      ) : null,
    );
  }
}