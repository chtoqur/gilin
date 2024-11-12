import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:developer';
import 'package:gilin/state/router/router_provider.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';


void main() async {
  await _initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 네이버맵 초기화
  await NaverMapSdk.instance.initialize(
      clientId: 'w5yq6v1x69',
      onAuthFailed: (e) => log("네이버맵 인증오류: $e", name: "onAuthFailed"));

  // 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '7e758a049b329a8bab71071c8ab8cb02',
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'GilIn',
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}
