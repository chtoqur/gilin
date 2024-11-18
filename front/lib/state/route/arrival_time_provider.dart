import 'package:flutter_riverpod/flutter_riverpod.dart';

final arrivalTimeProvider = StateProvider<ArrivalTime?>((ref) => null);

class ArrivalTime {
  final DateTime targetTime;
  final DateTime startTime;

  const ArrivalTime({
    required this.targetTime,
    required this.startTime,
  });

  // 편의를 위한 팩토리 메서드 추가
  factory ArrivalTime.fromMinutes(int minutes) {
    return ArrivalTime(
      targetTime: DateTime.now().add(Duration(minutes: minutes)),
      startTime: DateTime.now(),
    );
  }

  // 남은 시간 계산을 위한 유틸리티 메서드
  Duration get remainingTime {
    final now = DateTime.now();
    return targetTime.difference(now);
  }

  // 진행률 계산을 위한 유틸리티 메서드
  double get progress {
    final now = DateTime.now();
    final totalDuration = targetTime.difference(startTime).inSeconds;
    final elapsedDuration = now.difference(startTime).inSeconds;

    if (totalDuration <= 0) return 1.0;
    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }
}