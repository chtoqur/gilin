import 'package:flutter/material.dart';
//import 'package:gilin/screens/bookmark/bookmark_screen.dart';
import 'package:gilin/screens/mypage/mypage_screen.dart';
import 'package:gilin/screens/route/route_screen.dart';
import 'package:gilin/screens/schedule/schedule_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginNavigationState();
}

class _LoginNavigationState extends State<LoginScreen> {
  int _selectedIndex = 1; // 기본 지도 화면으로 초기화

  // 네비게이션 바의 각 탭에서 표시할 화면 리스트
  final List<Widget> _screens = [
    //const BookmarkScreen(),
    const RouteScreen(),
    const ScheduleScreen(),
    const LoginScreenUI(), // 로그인 UI를 포함하는 화면
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
        child: _screens[_selectedIndex], // 현재 선택된 화면을 표시
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
        selectedItemColor: const Color(0xfff4a700),
        unselectedItemColor: const Color(0xff3a3a3a),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// 로그인 UI를 포함하는 별도 위젯
class LoginScreenUI extends StatelessWidget {
  const LoginScreenUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 깔끔한 디자인을 위해 좌, 우로 패딩을 줍니다.
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // 세로로 중앙 배치합니다.
          mainAxisAlignment: MainAxisAlignment.center,
          // 가로는 최대한의 크기로 늘려줍니다.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 로고를 화면 너비의 절반만큼의 크기로 렌더링하고 가운데 정렬합니다.
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/img/logo.png',
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5,
              ),
            ),
            const SizedBox(height: 16.0),
            // 로그인 텍스트 필드
            TextFormField(),
            const SizedBox(height: 8.0),
            // 비밀번호 텍스트 필드
            TextFormField(),
            const SizedBox(height: 16.0),
            // [회원가입] 버튼
            ElevatedButton(
              onPressed: () {},
              child: Text('회원가입'),
            ),
            // [로그인] 버튼
            ElevatedButton(
              onPressed: () async {},
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}