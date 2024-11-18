import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/screens/mypage/add_myplace_screen.dart';
import 'package:gilin/screens/mypage/modify_user_info_screen.dart';
import 'package:gilin/screens/mypage/myplace_screen.dart';
import 'package:gilin/screens/mypage/notification_setting_screen.dart';
import 'package:gilin/screens/route/failure_screen.dart';
import 'package:gilin/screens/route/my_route_screen.dart';
import 'package:gilin/screens/route/success_screen.dart';
import 'package:gilin/screens/search/search_screen.dart';
import 'package:gilin/screens/signup/signup_step1_screen.dart';
import 'package:gilin/screens/signup/signup_step2_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:gilin/screens/alert/alert_screen.dart';
import 'package:gilin/screens/mypage/mypage_screen.dart';
import 'package:gilin/screens/mypage/test_screen.dart';
import 'package:gilin/screens/route/route_screen.dart';
import 'package:gilin/screens/schedule/schedule_screen.dart';
import 'package:gilin/screens/main_screen.dart';
import 'package:gilin/screens/guide/guide_main_screen.dart';
import 'package:gilin/models/route/transit_route.dart';
import 'package:gilin/state/route/route_state.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/guide/main',
        builder: (context, state) {
          // extra에서 필요한 데이터 추출
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
          TransitRoute routeData = extra['routeData'] as TransitRoute;
          RouteState routeState = extra['routeState'] as RouteState;

          return GuideMainScreen(
            routeData: routeData,
            routeState: routeState,
          );
        },
      ),
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
            path: '/test',
            builder: (context, state) => const TestScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/signup_step1',
            builder: (context, state) => const SignupStep1Screen(),
          ),
          GoRoute(
            path: '/signup_step2',
            builder: (context, state) => const SignupStep2Screen(),
          ),
          GoRoute(
            path: '/success',
            builder: (context, state) => const SuccessScreen(),
          ),
          GoRoute(
            path: '/failure',
            builder: (context, state) => const FailureScreen(),
          ),
          GoRoute(
            path: '/modify_user',
            builder: (context, state) => const ModifyUserInfoScreen(),
          ),
          GoRoute(
            path: '/notification_setting',
            builder: (context, state) => const NotificationSettingScreen(),
          ),
          GoRoute(
            path: '/myplace',
            builder: (context, state) => const MyplaceScreen(),
          ),
          GoRoute(
            path: '/add_myplace',
            builder: (context, state) => const AddMyPlaceScreen(),
          ),
        ],
      ),
    ],
    initialLocation: '/route',
  );
});
