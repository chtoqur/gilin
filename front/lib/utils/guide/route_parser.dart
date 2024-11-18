import 'package:gilin/models/guide/tracking_point.dart';
import 'package:gilin/models/route/transit_route.dart';

class RouteParser {
  static List<TrackingPoint> parseRouteData(TransitRoute routeData) {
    List<TrackingPoint> trackingPoints = [];
    var subPaths = routeData.subPath;

    for (int i = 0; i < subPaths.length; i++) {
      var segment = subPaths[i];
      var isLastSegment = i == subPaths.length - 1;
      var lane = segment.lane.isNotEmpty ? segment.lane[0] : null;

      if (segment.travelType == TransitType.METRO ||
          segment.travelType == TransitType.BUS) {
        trackingPoints.add(TrackingPoint(
          travelType: _convertToTravelType(segment.travelType),
          startX: segment.startX,
          startY: segment.startY,
          endX: segment.endX,
          endY: segment.endY,
          startName: segment.startName,
          routeName: segment.travelType == TransitType.METRO
              ? lane?.name
              : lane?.busNo,
          isLastPoint: isLastSegment,
        ));
      } else if (segment.travelType == TransitType.WALK) {
        // Add start point for walking
        trackingPoints.add(TrackingPoint(
          travelType: TravelType.WALK,
          startX: segment.startX,
          startY: segment.startY,
          endX: segment.endX,
          endY: segment.endY,
          isLastPoint: isLastSegment,
        ));

        // Add end point for walking (as a separate tracking point)
        if (!isLastSegment) {
          trackingPoints.add(TrackingPoint(
            travelType: TravelType.WALK,
            startX: segment.startX,
            startY: segment.startY,
            endX: segment.endX,
            endY: segment.endY,
            isLastPoint: false,
          ));
        }
      }
    }

    return trackingPoints;
  }

  // TransitType을 TravelType으로 변환하는 헬퍼 메서드
  static TravelType _convertToTravelType(TransitType transitType) {
    switch (transitType) {
      case TransitType.METRO:
        return TravelType.METRO;
      case TransitType.BUS:
        return TravelType.BUS;
      case TransitType.WALK:
        return TravelType.WALK;
      case TransitType.TRANSFER:
        return TravelType.TRANSFER;
      case TransitType.TAXI:
        return TravelType.TAXI;
      case TransitType.BICYCLE:
        return TravelType.BICYCLE;
      default:
        return TravelType.WALK;
    }
  }
}