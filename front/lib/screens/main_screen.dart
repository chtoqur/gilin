import 'package:flutter/material.dart';
import 'alert/alert_screen.dart';
import 'bookmark/bookmark_screen.dart';
import 'mypage/mypage_screen.dart';
import 'route/route_screen.dart';
import 'schedule/schedule_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainScreen> {
  // 초기화면: 지도
  int _selectedIndex = 1;

  // 표시할 화면 리스트
  final List<Widget> _screens = [
    // const AlertScreen(),
    const BookmarkScreen(),
    const RouteScreen(),
    const ScheduleScreen(),
    const MypageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '저장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MY',
          ),
        ],
        // 선택된 아이템 색상
        selectedItemColor: const Color(0xfff4a700),
        // 선택되지 않은 아이템 색상
        unselectedItemColor: const Color(0xff3a3a3a),
        // 선택된 라벨 스타일
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        // 아이템이 3개 이상일 때 필요
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}