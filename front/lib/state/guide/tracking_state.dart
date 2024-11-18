import 'package:gilin/models/guide/tracking_point.dart';

class TrackingState {
  final List<TrackingPoint> points;
  final int currentIndex;
  final bool isTrackingEnd;
  final bool isTrackingStart;

  TrackingState({
    required this.points,
    required this.currentIndex,
    this.isTrackingEnd = false,
    this.isTrackingStart = true,
  });

  TrackingState copyWith({
    List<TrackingPoint>? points,
    int? currentIndex,
    bool? isTrackingEnd,
    bool? isTrackingStart,
  }) {
    return TrackingState(
      points: points ?? this.points,
      currentIndex: currentIndex ?? this.currentIndex,
      isTrackingEnd: isTrackingEnd ?? this.isTrackingEnd,
      isTrackingStart: isTrackingStart ?? this.isTrackingStart,
    );
  }
}