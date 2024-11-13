import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:developer';
import 'package:gilin/state/router/router_provider.dart';

void main() async {
  await _initialize();
  if (kDebugMode) {
    // FrameEvents 로그 필터링
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message?.contains('FrameEvents') ?? false) return;
      print(message);
    };
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'w5yq6v1x69',
      onAuthFailed: (e) => log("네이버맵 인증오류: $e", name: "onAuthFailed"));
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
