import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../themes/path_color.dart';
import '../../models/route/transit_route.dart';

class PathStyleUtils {
  static Color getPathColor(TransitSegment segment) {
    switch (segment.travelType) {
      case TransitType.METRO:
        if (segment.lane.isNotEmpty) {
          final subwayCode = segment.lane.first.subwayCode;
          return PathColors.subwayColors[subwayCode] ?? PathColors.defaultSubwayColor;
        }
        return PathColors.defaultSubwayColor;

      case TransitType.BUS:
        if (segment.lane.isNotEmpty) {
          final busType = segment.lane.first.type;
          return PathColors.busColors[busType] ?? PathColors.defaultBusColor;
        }
        return PathColors.defaultBusColor;

      case TransitType.TAXI:
        return PathColors.taxiColor;

      case TransitType.BICYCLE:
        return PathColors.bicycleColor;

      case TransitType.WALK:
        return PathColors.walkColor;
    }
  }

  static List<NLatLng> _createDashedLine(List<NLatLng> coords) {
    List<NLatLng> dashedCoords = [];
    final double dashLength = 0.00001; // 점선 하나의 길이 (위도/경도 단위)

    for (int i = 0; i < coords.length - 1; i++) {
      final start = coords[i];
      final end = coords[i + 1];

      // 두 점 사이의 거리와 방향 계산
      final latDiff = end.latitude - start.latitude;
      final lngDiff = end.longitude - start.longitude;
      final distance = sqrt(pow(latDiff, 2) + pow(lngDiff, 2));

      // 이 선분에 필요한 대시의 개수 계산
      final numDashes = (distance / (dashLength * 2)).floor();

      if (numDashes == 0) {
        // 거리가 너무 짧으면 그냥 하나의 선으로 처리
        dashedCoords.add(start);
        dashedCoords.add(end);
        continue;
      }

      // 실제 사용할 대시 길이 계산 (균등 분배)
      final adjustedDashLength = distance / (numDashes * 2);

      // 단위 벡터 계산
      final unitLatDiff = latDiff / distance;
      final unitLngDiff = lngDiff / distance;

      for (int j = 0; j < numDashes; j++) {
        // 대시의 시작점
        final dashStart = NLatLng(
          start.latitude + (unitLatDiff * adjustedDashLength * j * 2),
          start.longitude + (unitLngDiff * adjustedDashLength * j * 2),
        );

        // 대시의 끝점
        final dashEnd = NLatLng(
          start.latitude + (unitLatDiff * adjustedDashLength * (j * 2 + 1)),
          start.longitude + (unitLngDiff * adjustedDashLength * (j * 2 + 1)),
        );

        dashedCoords.add(dashStart);
        dashedCoords.add(dashEnd);
      }
    }

    return dashedCoords;
  }
  static List<NPathOverlay> createPathOverlay({
    required String id,
    required List<NLatLng> coords,
    required TransitSegment segment,
    double zoomLevel = 15.0, // 기본 줌 레벨 추가
  }) {
    final color = getPathColor(segment);

    if (segment.travelType == TransitType.WALK) {
      List<NPathOverlay> dashOverlays = [];
      // 줌 레벨에 따라 간격 조정 (줌이 커질수록 간격이 작아짐)
      final double baseSpacing = 0.0005 / pow(1.5, (zoomLevel - 15)); // 간격을 더 크게
      final double dotSize = 0.00001; // 점 크기

      for (int i = 0; i < coords.length - 1; i++) {
        final start = coords[i];
        final end = coords[i + 1];

        final latDiff = end.latitude - start.latitude;
        final lngDiff = end.longitude - start.longitude;
        final distance = sqrt(pow(latDiff, 2) + pow(lngDiff, 2));

        // 간격이 baseSpacing보다 작으면 건너뛰기
        if (distance < baseSpacing) continue;

        final numDots = (distance / baseSpacing).floor();
        if (numDots == 0) continue;

        final unitLatDiff = latDiff / distance;
        final unitLngDiff = lngDiff / distance;

        for (int j = 0; j < numDots; j++) {
          final dotCenter = NLatLng(
            start.latitude + (unitLatDiff * baseSpacing * j),
            start.longitude + (unitLngDiff * baseSpacing * j),
          );

          // 아주 작은 원을 만들기 위한 두 점
          final dotStart = NLatLng(
            dotCenter.latitude - (dotSize / 2),
            dotCenter.longitude,
          );
          final dotEnd = NLatLng(
            dotCenter.latitude + (dotSize / 2),
            dotCenter.longitude,
          );

          dashOverlays.add(NPathOverlay(
            id: '${id}_dot_${i}_$j',
            coords: [dotStart, dotEnd],
            color: color,
            width: 8, // 점의 높이 (더 크게 설정하여 원형으로)
            outlineColor: Colors.white,
            outlineWidth: 1,
          ));
        }
      }

      return dashOverlays;
    }

    // 도보가 아닌 경우 단일 실선
    return [NPathOverlay(
      id: id,
      coords: coords,
      color: color,
      width: 5,
      outlineColor: Colors.white,
      outlineWidth: 2,
      passedColor: color.withOpacity(0.5),
      progress: 0.0,
    )];
  }
}