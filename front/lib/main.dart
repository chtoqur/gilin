import 'package:flutter/material.dart';
import 'package:gilin/screens/main_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:developer';

void main() async {
  await _initialize();
  runApp(
    const MaterialApp(
      home: MainScreen(),
    )
  );
}

// 지도 초기화
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'w5yq6v1x69',
      onAuthFailed: (e) => log("네이버맵 인증오류: $e", name: "onAuthFailed")
  );
}