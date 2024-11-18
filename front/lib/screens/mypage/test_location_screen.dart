// lib/screens/test_dialog_screen.dart
import 'package:flutter/material.dart';
import 'package:gilin/models/route/transit_route.dart';
import 'package:gilin/widgets/shared/popup/confirm_boarding.dart';

class TestLocationScreen extends StatelessWidget {
  const TestLocationScreen({Key? key}) : super(key: key);

  void _showBoardingPopup(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100, // 원하는 위치 조정
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: ConfirmBoardingPopup(
            transitType: 'BUS',
            stationName: '역삼역',
            routeName: '2호선',
            onConfirm: () {
              // overlayEntry.remove();
              // 확인 처리
            },
            onCancel: () {
              // overlayEntry.remove();
              // 취소 처리
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 테스트'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showBoardingPopup(context),
              child: const Text('팝업 표시'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}