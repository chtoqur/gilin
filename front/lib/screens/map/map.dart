import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  await _initialize();
  runApp(const NaverMapApp());
}

// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: 'w5yq6v1x69',
    onAuthFailed: (e) => log("네이버맵 인증오류: $e", name: "onAuthFailed")
  );
}

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // NaverMapController 객체의 비동기 작업 완료를 나타내는 Completer 생성
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,            // 실내 맵 사용 가능 여부 설정
            locationButtonEnable: false,   // 위치 버튼 표시 여부 설정
            consumeSymbolTapEvents: false, // 위치 버튼 표시 여부 설정
          ),
          onMapReady: (controller) async {
            mapControllerCompleter.complete(controller);
            log("onMapReady", name: "onMapReady");
          },
        ),
      ),
    );
  }
}