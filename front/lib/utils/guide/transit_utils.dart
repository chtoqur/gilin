import 'package:flutter/material.dart';
import '../../models/route/transit_route.dart';

class TransitUtils {
  static IconData getTransitIcon(TransitType type) {
    switch (type) {
      case TransitType.BUS:
        return Icons.directions_bus;
      case TransitType.METRO:
        return Icons.subway;
      case TransitType.TAXI:
        return Icons.local_taxi;
      case TransitType.WALK:
        return Icons.directions_walk;
      case TransitType.BICYCLE:
        return Icons.pedal_bike;
      case TransitType.TRANSFER:
        return Icons.pedal_bike;
    }
  }

  static String getTransitTypeText(TransitType type) {
    switch (type) {
      case TransitType.BUS:
        return '버스';
      case TransitType.METRO:
        return '지하철';
      case TransitType.TAXI:
        return '택시';
      case TransitType.WALK:
        return '도보';
      case TransitType.BICYCLE:
        return '자전거';
      case TransitType.TRANSFER:
        return '환승';
    }
  }
}