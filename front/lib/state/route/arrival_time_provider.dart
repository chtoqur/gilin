import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final arrivalTimerProvider = StateNotifierProvider<ArrivalTimerNotifier, TimerState>((ref) {
  return ArrivalTimerNotifier();
});

class TimerState {
  final double progress;
  final DateTime? endTime;

  TimerState({
    this.progress = 0.0,
    this.endTime,
  });

  TimerState copyWith({
    double? progress,
    DateTime? endTime,
  }) {
    return TimerState(
      progress: progress ?? this.progress,
      endTime: endTime ?? this.endTime,
    );
  }
}

class ArrivalTimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  ArrivalTimerNotifier() : super(TimerState());

  void startTimer(DateTime endTime) {
    _timer?.cancel();
    var startTime = DateTime.now();

    state = TimerState(
      progress: 0.0,
      endTime: endTime,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      var now = DateTime.now();
      var totalDuration = endTime.difference(startTime).inSeconds;
      var elapsedDuration = now.difference(startTime).inSeconds;

      if (elapsedDuration >= totalDuration) {
        state = state.copyWith(progress: 1.0);
        _timer?.cancel();
        return;
      }

      var progress = elapsedDuration / totalDuration;
      state = state.copyWith(progress: progress.clamp(0.0, 1.0));
    });
  }

  void stopTimer() {
    _timer?.cancel();
    state = TimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}