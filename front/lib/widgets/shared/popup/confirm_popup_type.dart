import 'package:flutter/material.dart';

enum PopupType {
  arrivalCheck,
  warningLate,
}

class PopupData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final String confirmButtonText;
  final String cancelButtonText;

  const PopupData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.confirmButtonText,
    required this.cancelButtonText,
  });
}

class PopupConfig {
  static const Map<PopupType, PopupData> popupData = {
    PopupType.arrivalCheck: PopupData(
      title: '목적지 도착',
      subtitle: '목표 시간에 맞춰 도착하셨나요?',
      icon: Icons.check,
      iconBackgroundColor: Color(0xFF8C9F5F),
      confirmButtonText: '잘 도착했어요',
      cancelButtonText: '늦었어요',
    ),
    PopupType.warningLate: PopupData(
      title: '지각 위험',
      subtitle: '지금 바로 택시에 타지 않으면 늦어요.\n택시에 탑승하시겠어요?',
      icon: Icons.warning,
      iconBackgroundColor: Color(0xFFFF5F5F),
      confirmButtonText: '택시타기',
      cancelButtonText: '기존 경로 안내',
    ),
  };
}