import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/navigation/navigation_provider.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentIndex = ref.watch(bottomNavProvider);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        var routes = ['/route', '/schedule', '/alert', '/mypage'];
        context.push('/${routes[index]}');
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
    );
  }
}
