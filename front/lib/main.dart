import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:gilin/state/auth/auth_provider.dart';
import 'package:gilin/state/auth/auth_state.dart';
import 'package:gilin/state/router/router_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 카카오 SDK 초기화
    KakaoSdk.init(
      nativeAppKey: '7e758a049b329a8bab71071c8ab8cb02',
    );

    var keyHash = await KakaoSdk.origin;
    print('Kakao Key Hash: $keyHash');

    // 네이버 지도 초기화
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
    );
  }
}
