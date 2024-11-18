import 'package:flutter/material.dart';

class ConfirmBoardingPopup extends StatelessWidget {
  final String transitType;
  final String? stationName;
  final String? routeName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmBoardingPopup({
    Key? key,
    required this.transitType,
    this.stationName,
    this.routeName,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    if (transitType == 'WALK') {
      message = stationName == null
          ? '도보 이용이 끝나셨나요?'
          : '도보 이용 중이신가요?';
    } else if (transitType == 'BUS') {
      message = '$stationName 도착! $routeName 탑승하셨나요?';
    } else if (transitType == 'METRO') {
      message = '$stationName 도착! $routeName 탑승하셨나요?';
    } else {
      message = '목적지에 도착하셨나요?';
    }

    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onCancel,
                    child: const Text('아니요'),
                  ),
                  ElevatedButton(
                    onPressed: onConfirm,
                    child: const Text('네'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
