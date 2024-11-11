// lib/models/route/transit_route.dart
import 'package:flutter_naver_map/flutter_naver_map.dart';

enum TransitType {
  bus,
  subway,
  taxi,
  walking,
  bicycle
}

class TransitSegment {
  final TransitType type;
  final List<NLatLng> coordinates;
  final String startName;
  final String endName;
  final int duration; // 소요 시간 (분)
  final double distance; // 거리 (미터)

  TransitSegment({
    required this.type,
    required this.coordinates,
    required this.startName,
    required this.endName,
    required this.duration,
    required this.distance,
  });

  factory TransitSegment.fromJson(Map<String, dynamic> json) {
    return TransitSegment(
      type: TransitType.values.firstWhere(
            (e) => e.toString() == 'TransitType.${json['type']}',
      ),
      coordinates: (json['coordinates'] as List).map((coord) {
        return NLatLng(coord[0], coord[1]);
      }).toList(),
      startName: json['start_name'],
      endName: json['end_name'],
      duration: json['duration'],
      distance: json['distance'].toDouble(),
    );
  }
}

class TransitRoute {
  final List<TransitSegment> segments;
  final int totalDuration;
  final double totalDistance;

  TransitRoute({
    required this.segments,
    required this.totalDuration,
    required this.totalDistance,
  });

  factory TransitRoute.fromJson(Map<String, dynamic> json) {
    var segmentsList = (json['segments'] as List)
        .map((segment) => TransitSegment.fromJson(segment))
        .toList();

    return TransitRoute(
      segments: segmentsList,
      totalDuration: json['total_duration'],
      totalDistance: json['total_distance'].toDouble(),
    );
  }
}