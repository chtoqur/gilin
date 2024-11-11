// lib/models/route/custom_route.dart
import 'package:flutter_naver_map/flutter_naver_map.dart';

class CustomRoute {
  final List<NLatLng> coordinates; // 경로를 구성하는 위도/경도 좌표들
  final int totalDistance; // 총 거리 (미터)
  final int estimatedTime; // 예상 소요 시간 (초)
  final String routeType; // 경로 타입 (예: 도보, 자전거 등)

  CustomRoute({
    required this.coordinates,
    required this.totalDistance,
    required this.estimatedTime,
    required this.routeType,
  });

  factory CustomRoute.fromJson(Map<String, dynamic> json) {
    // coordinates 배열은 [[위도, 경도], [위도, 경도], ...] 형식으로 가정
    var coordsList = (json['coordinates'] as List).map((coord) {
      var point = coord as List;
      return NLatLng(point[0], point[1]); // 위도, 경도
    }).toList();

    return CustomRoute(
      coordinates: coordsList,
      totalDistance: json['total_distance'] ?? 0,
      estimatedTime: json['estimated_time'] ?? 0,
      routeType: json['route_type'] ?? 'walking',
    );
  }
}