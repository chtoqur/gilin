import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gilin/state/auth/auth_state.dart';
import 'dart:developer';
import 'package:gilin/state/router/router_provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:gilin/state/auth/auth_provider.dart';

void main() async {
  // Flutter 바인딩 초기화

  WidgetsFlutterBinding.ensureInitialized();

  // 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '7e758a049b329a8bab71071c8ab8cb02',
  );

  try {
    // 키 해시 출력
    var keyHash = await KakaoSdk.origin;
    print('Kakao Key Hash: $keyHash');

    // 네이버 지도 초기화는 카카오 SDK 초기화 후에 실행
    await NaverMapSdk.instance.initialize(
      clientId: 'w5yq6v1x69',
      onAuthFailed: (e) => log("네이버맵 인증오류: $e", name: "onAuthFailed"),
    );

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    print('초기화 중 오류 발생: $e');
  }
}

// _initialize 함수는 제거 (중복된 초기화를 방지하기 위해)

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var router = ref.watch(routerProvider);

    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      next.whenData((state) {
        if (state is AuthUnauthenticated) {
          router.go('/login');
        }
      });
    });

    return MaterialApp.router(
      routerConfig: router,
      title: 'GilIn',
      theme: ThemeData(
        primaryColor: Colors.white,
        // 필요한 경우 추가 테마 설정
      ),
      // 디버그 배너 제거 (선택사항)
      debugShowCheckedModeBanner: false,
    );
  }
}