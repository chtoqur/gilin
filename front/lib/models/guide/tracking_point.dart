enum TravelType { METRO, BUS, TAXI, BICYCLE, WALK, TRANSFER }

class TrackingPoint {
  final TravelType travelType;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final String? startName;
  final String? routeName; // METRO: lane.name / BUS: lane.busNo
  final bool isLastPoint;

  TrackingPoint({
    required this.travelType,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    this.startName,
    this.routeName,
    required this.isLastPoint,
  });
}