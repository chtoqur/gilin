// lib/utils/path_style_utils.dart
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

  static NPathOverlay createPathOverlay({
    required String id,
    required List<NLatLng> coords,
    required TransitSegment segment,
  }) {
    if (segment.travelType == TransitType.WALK) {
      // 도보 경로는 점선으로 표시
      return NPathOverlay(
        id: id,
        coords: coords,
        color: PathColors.walkColor,
        width: 5,
        outlineColor: Colors.white,
        outlineWidth: 2,
        patternImage: NOverlayImage.fromAssetImage('assets/images/route/walk_pattern.png'),
        patternInterval: 30,
      );
    }


    // 다른 이동수단은 실선으로 표시
    return NPathOverlay(
      id: id,
      coords: coords,
      color: getPathColor(segment),
      width: 5,
      outlineColor: Colors.white,
      outlineWidth: 2,
    );
  }
}