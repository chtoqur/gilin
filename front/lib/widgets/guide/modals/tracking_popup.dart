import 'package:flutter/material.dart';
import 'package:gilin/models/route/transit_route.dart';

class TrackingPopup extends StatelessWidget {
  final TransitType travelType;
  final String? name;
  final String? lineInfo;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const TrackingPopup({
    super.key,  // key를 super.key로 변경
    required this.travelType,
    this.name,
    this.lineInfo,
    required this.onConfirm,
    required this.onCancel,
  });

  String _getMessage() {
    switch (travelType) {
      case TransitType.METRO:
        return '${name ?? ''} ${lineInfo ?? ''}에\n탑승하시나요?';
      case TransitType.BUS:
        return '${name ?? ''}에서\n${lineInfo ?? ''} 버스에 탑승하시나요?';
      case TransitType.WALK:
        if (name != null) {
          return '도보 이동을 완료하셨나요?';
        } else {
          return '도보 이동을\n시작하시나요?';
        }
      default:
        return '다음 구간으로\n이동하시나요?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(  // SafeArea 추가하여 상단 노치 영역 피하기
        child: Container(
          margin: const EdgeInsets.only(top: 60),  // 상단 마진 추가
          alignment: Alignment.topCenter,  // 상단 정렬
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),  // 좌우 마진
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(  // Flexible 추가하여 텍스트 오버플로우 방지
                  child: Text(
                    _getMessage(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '아니요',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onConfirm,
                      style: TextButton.styleFrom(
                        backgroundColor: _getColor(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '네',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (travelType) {
      case TransitType.METRO:
        return const Color(0xFF3B82F6);  // 파란색
      case TransitType.BUS:
        return const Color(0xFF22C55E);  // 초록색
      case TransitType.WALK:
        return const Color(0xFFF97316);  // 주황색
      default:
        return const Color(0xFF6B7280);  // 회색
    }
  }

  IconData _getIcon() {
    switch (travelType) {
      case TransitType.METRO:
        return Icons.subway;
      case TransitType.BUS:
        return Icons.directions_bus;
      case TransitType.WALK:
        return Icons.directions_walk;
      default:
        return Icons.directions;
    }
  }
}