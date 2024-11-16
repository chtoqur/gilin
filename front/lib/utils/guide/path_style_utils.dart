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

      case TransitType.TRANSFER:
        return PathColors.walkColor;
    }
  }

  static List<NPathOverlay> createPathOverlay({
    required String id,
    required List<NLatLng> coords,
    required TransitSegment segment,
    required double zoomLevel,
  }) {
    if (segment.travelType != TransitType.WALK) {
      return [NPathOverlay(
        id: id,
        coords: coords,
        color: getPathColor(segment),
        width: 5,
        outlineColor: Colors.white,
        outlineWidth: 2,
        passedColor: getPathColor(segment).withOpacity(0.5),
        progress: 0.0,
      )];
    }

    final List<NPathOverlay> dashOverlays = [];
    final color = getPathColor(segment);

    // 줌 레벨에 따른 점선 패턴 조정
    double dashLength = _calculateDashLength(zoomLevel);
    double gapLength = dashLength; // 간격은 점 길이와 동일하게 설정

    for (int i = 0; i < coords.length - 1; i++) {
      final start = coords[i];
      final end = coords[i + 1];

      final segments = _createDashedSegments(start, end, dashLength, gapLength);

      for (int j = 0; j < segments.length; j += 2) {
        if (j + 1 >= segments.length) break;

        dashOverlays.add(NPathOverlay(
          id: '${id}_dash_${i}_${j ~/ 2}',
          coords: [segments[j], segments[j + 1]],
          color: color,
          width: 4,
          outlineColor: Colors.white,
          outlineWidth: 1,
        ));
      }
    }

    return dashOverlays;
  }

  static double _calculateDashLength(double zoomLevel) {
    // 줌 레벨에 따른 대시 길이 조정
    const baseLength = 0.0001;
    return baseLength / pow(2, (zoomLevel - 15));
  }

  static List<NLatLng> _createDashedSegments(
      NLatLng start,
      NLatLng end,
      double dashLength,
      double gapLength
      ) {
    List<NLatLng> segments = [];
    final latDiff = end.latitude - start.latitude;
    final lngDiff = end.longitude - start.longitude;
    final distance = sqrt(pow(latDiff, 2) + pow(lngDiff, 2));

    if (distance < dashLength) {
      segments.add(start);
      segments.add(end);
      return segments;
    }

    final patternLength = dashLength + gapLength;
    final count = (distance / patternLength).floor();

    final unitLatDiff = latDiff / distance;
    final unitLngDiff = lngDiff / distance;

    for (int i = 0; i < count; i++) {
      final dashStart = NLatLng(
        start.latitude + (unitLatDiff * i * patternLength),
        start.longitude + (unitLngDiff * i * patternLength),
      );

      final dashEnd = NLatLng(
        start.latitude + (unitLatDiff * (i * patternLength + dashLength)),
        start.longitude + (unitLngDiff * (i * patternLength + dashLength)),
      );

      segments.add(dashStart);
      segments.add(dashEnd);
    }

    return segments;
  }
}