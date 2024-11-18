import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/route/transit_route.dart';

class TrackingState {
  final List<TrackingPoint> points;
  final int currentIndex;
  final bool showAlert;

  TrackingState({
    required this.points,
    this.currentIndex = 0,
    this.showAlert = false,
  });

  TrackingPoint get currentPoint => points[currentIndex];
  bool get isTrackingEnd => currentIndex >= points.length - 1;

  TrackingState copyWith({
    int? currentIndex,
    bool? showAlert,
  }) {
    return TrackingState(
      points: points,
      currentIndex: currentIndex ?? this.currentIndex,
      showAlert: showAlert ?? this.showAlert,
    );
  }
}

class TrackingPoint {
  final TransitType travelType;
  final double startX, startY;
  final double endX, endY;
  final String? stationName;
  final String? laneInfo;

  TrackingPoint({
    required this.travelType,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    this.stationName,
    this.laneInfo,
  });
}

class GuideTrackingNotifier extends StateNotifier<TrackingState> {
  GuideTrackingNotifier() : super(TrackingState(points: []));

  void initializeTracking(TransitRoute routeData) {
    final points = <TrackingPoint>[];

    for (var segment in routeData.subPath) {
      if (segment.travelType == 'METRO' || segment.travelType == 'BUS') {
        points.add(TrackingPoint(
          travelType: segment.travelType,
          startX: segment.startX,
          startY: segment.startY,
          endX: segment.endX,
          endY: segment.endY,
          stationName: segment.startName,
          laneInfo: segment.travelType == 'METRO'
              ? segment.lane.first.name
              : segment.lane.first.busNo,
        ));
      } else if (segment.travelType == 'WALK') {
        points.add(TrackingPoint(
          travelType: TransitType.WALK,
          startX: segment.startX,
          startY: segment.startY,
          endX: segment.endX,
          endY: segment.endY,
        ));
      }
    }

    state = TrackingState(points: points);
  }

  void checkProximity(double userX, double userY) {
    final current = state.currentPoint;
    final distance = Geolocator.distanceBetween(
      userX, userY,
      current.startY, current.startX,
    );

    if (distance < 100) {
      state = state.copyWith(showAlert: true);
    }
  }

  void moveToNext() {
    if (state.isTrackingEnd) return;
    state = state.copyWith(currentIndex: state.currentIndex + 1, showAlert: false);
  }

  void hideAlert() {
    state = state.copyWith(showAlert: false);
  }
}

final guideTrackingProvider =
StateNotifierProvider<GuideTrackingNotifier, TrackingState>(
        (ref) => GuideTrackingNotifier());
