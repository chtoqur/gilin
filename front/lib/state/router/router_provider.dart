import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/screens/route/my_route_screen.dart';
import 'package:gilin/screens/search/search_screen.dart';
import 'package:gilin/screens/signup/signup_step1_screen.dart';
import 'package:gilin/screens/signup/signup_step2_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:gilin/screens/alert/alert_screen.dart';
import 'package:gilin/screens/mypage/mypage_screen.dart';
import 'package:gilin/screens/route/route_screen.dart';
import 'package:gilin/screens/schedule/schedule_screen.dart';
import 'package:gilin/screens/main_screen.dart';

import '../../screens/login/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScreen(
          // 네브바가 없어야 하는 페이지
          showBottomNav: !state.uri.path.contains('/test'),
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/route',
            builder: (context, state) => const RouteScreen(),
          ),
          GoRoute(
            path: '/my_route',
            builder: (context, state) => const MyRouteScreen(),
          ),
          GoRoute(
            path: '/schedule',
            builder: (context, state) => const ScheduleScreen(),
          ),
          GoRoute(
            path: '/alert',
            builder: (context, state) => const AlertScreen(),
          ),
          GoRoute(
            path: '/mypage',
            builder: (context, state) => MypageScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/login',  // 로그인 경로 추가
            builder: (context, state) => const LoginScreenUI(),
          ),
          GoRoute(
            path: '/signup_step1',
            builder: (context, state) => const SignupStep1Screen(),
          ),
          GoRoute(
            path: '/signup_step2',
            builder: (context, state) => const SignupStep2Screen(),
          ),
        ],
      ),
    ],
    initialLocation: '/route',
  );
});
