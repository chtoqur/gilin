// lib/models/route/transit_route.dart

import 'package:flutter_naver_map/flutter_naver_map.dart';

enum TransitType {
  METRO,
  BUS,
  TAXI,
  BICYCLE,
  WALK,
  TRANSFER,
}

class RouteInfo {
  final int trafficDistance;
  final int totalWalk;
  final int totalTime;
  final int payment;
  final int busTransitCount;
  final int subwayTransitCount;
  final String firstStartStation;
  final String lastEndStation;
  final int totalStationCount;
  final int busStationCount;
  final int subwayStationCount;
  final int totalDistance;
  final int totalIntervalTime;

  RouteInfo({
    required this.trafficDistance,
    required this.totalWalk,
    required this.totalTime,
    required this.payment,
    required this.busTransitCount,
    required this.subwayTransitCount,
    required this.firstStartStation,
    required this.lastEndStation,
    required this.totalStationCount,
    required this.busStationCount,
    required this.subwayStationCount,
    required this.totalDistance,
    required this.totalIntervalTime,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      trafficDistance: (json['trafficDistance'] ?? 0).toInt(),
      totalWalk: (json['totalWalk'] ?? 0).toInt(),
      totalTime: (json['totalTime'] ?? 0).toInt(),
      payment: (json['payment'] ?? 0).toInt(),
      busTransitCount: (json['busTransitCount'] ?? 0).toInt(),
      subwayTransitCount: (json['subwayTransitCount'] ?? 0).toInt(),
      firstStartStation: json['firstStartStation'] ?? '',
      lastEndStation: json['lastEndStation'] ?? '',
      totalStationCount: (json['totalStationCount'] ?? 0).toInt(),
      busStationCount: (json['busStationCount'] ?? 0).toInt(),
      subwayStationCount: (json['subwayStationCount'] ?? 0).toInt(),
      totalDistance: (json['totalDistance'] ?? 0).toInt(),
      totalIntervalTime: (json['totalIntervalTime'] ?? 0).toInt(),
    );
  }
}

class Lane {
  final String name;
  final String busNo;
  final int type;
  final int busID;
  final String busLocalBlID;
  final int subwayCode;

  Lane({
    required this.name,
    required this.busNo,
    required this.type,
    required this.busID,
    required this.busLocalBlID,
    required this.subwayCode,
  });

  factory Lane.fromJson(Map<String, dynamic> json) {
    return Lane(
      name: json['name'] ?? '',
      busNo: json['busNo'] ?? '',
      type: json['type'] ?? 0,
      busID: json['busID'] ?? 0,
      busLocalBlID: json['busLocalBlID'] ?? '',
      subwayCode: json['subwayCode'] ?? 0,
    );
  }
}

class Station {
  final int index;
  final int stationID;
  final String stationName;
  final String localStationID;
  final String arsID;
  final String x;
  final String y;
  final String isNonStop;

  Station({
    required this.index,
    required this.stationID,
    required this.stationName,
    required this.localStationID,
    required this.arsID,
    required this.x,
    required this.y,
    required this.isNonStop,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      index: json['index'] ?? 0,
      stationID: json['stationID'] ?? 0,
      stationName: json['stationName'] ?? '',
      localStationID: json['localStationID'] ?? '',
      arsID: json['arsID'] ?? '',
      x: json['x'] ?? '',
      y: json['y'] ?? '',
      isNonStop: json['isNonStop'] ?? '',
    );
  }
}

class PassStopList {
  final List<Station> stations;

  PassStopList({
    required this.stations,
  });

  factory PassStopList.fromJson(Map<String, dynamic> json) {
    var stationsList = (json['stations'] as List? ?? [])
        .map((station) => Station.fromJson(station))
        .toList();

    return PassStopList(stations: stationsList);
  }
}

class TransitSegment {
  final TransitType travelType;
  final List<NLatLng> pathGraph;
  final double distance;
  final int sectionTime;
  final int stationCount;
  final List<Lane> lane;
  final int intervalTime;
  final String startName;
  final double startX;
  final double startY;
  final String endName;
  final double endX;
  final double endY;
  final String way;
  final int wayCode;
  final String? door;
  final int startID;
  final String startLocalStationID;
  final String startArsID;
  final int endID;
  final String endLocalStationID;
  final String endArsID;
  final String? startExitNo;
  final double? startExitX;
  final double? startExitY;
  final String? endExitNo;
  final double? endExitX;
  final double? endExitY;
  final PassStopList passStopList;

  TransitSegment({
    required this.travelType,
    required this.pathGraph,
    required this.distance,
    required this.sectionTime,
    required this.stationCount,
    required this.lane,
    required this.intervalTime,
    required this.startName,
    required this.startX,
    required this.startY,
    required this.endName,
    required this.endX,
    required this.endY,
    required this.way,
    required this.wayCode,
    this.door,
    required this.startID,
    required this.startLocalStationID,
    required this.startArsID,
    required this.endID,
    required this.endLocalStationID,
    required this.endArsID,
    this.startExitNo,
    this.startExitX,
    this.startExitY,
    this.endExitNo,
    this.endExitX,
    this.endExitY,
    required this.passStopList,
  });

  factory TransitSegment.fromJson(Map<String, dynamic> json) {
    var pathGraphList = (json['pathGraph'] as List? ?? []).map((point) {
      return NLatLng(
        (point['y'] is String) ? double.parse(point['y']) : (point['y'] ?? 0).toDouble(),
        (point['x'] is String) ? double.parse(point['x']) : (point['x'] ?? 0).toDouble(),
      );
    }).toList();

    return TransitSegment(
      travelType: TransitType.values.firstWhere(
            (e) => e.toString().split('.').last == json['travelType'],
        orElse: () => TransitType.WALK,
      ),
      pathGraph: pathGraphList,
      distance: (json['distance'] is String)
          ? double.parse(json['distance'])
          : (json['distance'] ?? 0).toDouble(),
      sectionTime: (json['sectionTime'] ?? 0).toInt(),
      stationCount: (json['stationCount'] ?? 0).toInt(),
      lane: (json['lane'] as List? ?? [])
          .map((lane) => Lane.fromJson(lane))
          .toList(),
      intervalTime: (json['intervalTime'] ?? 0).toInt(),
      startName: json['startName'] ?? '',
      startX: (json['startX'] is String)
          ? double.parse(json['startX'])
          : (json['startX'] ?? 0).toDouble(),
      startY: (json['startY'] is String)
          ? double.parse(json['startY'])
          : (json['startY'] ?? 0).toDouble(),
      endName: json['endName'] ?? '',
      endX: (json['endX'] is String)
          ? double.parse(json['endX'])
          : (json['endX'] ?? 0).toDouble(),
      endY: (json['endY'] is String)
          ? double.parse(json['endY'])
          : (json['endY'] ?? 0).toDouble(),
      way: json['way'] ?? '',
      wayCode: (json['wayCode'] ?? 0).toInt(),
      door: json['door'],
      startID: (json['startID'] ?? 0).toInt(),
      startLocalStationID: json['startLocalStationID'] ?? '',
      startArsID: json['startArsID'] ?? '',
      endID: (json['endID'] ?? 0).toInt(),
      endLocalStationID: json['endLocalStationID'] ?? '',
      endArsID: json['endArsID'] ?? '',
      startExitNo: json['startExitNo'],
      startExitX: json['startExitX'] != null
          ? ((json['startExitX'] is String)
          ? double.parse(json['startExitX'])
          : json['startExitX'].toDouble())
          : null,
      startExitY: json['startExitY'] != null
          ? ((json['startExitY'] is String)
          ? double.parse(json['startExitY'])
          : json['startExitY'].toDouble())
          : null,
      endExitNo: json['endExitNo'],
      endExitX: json['endExitX'] != null
          ? ((json['endExitX'] is String)
          ? double.parse(json['endExitX'])
          : json['endExitX'].toDouble())
          : null,
      endExitY: json['endExitY'] != null
          ? ((json['endExitY'] is String)
          ? double.parse(json['endExitY'])
          : json['endExitY'].toDouble())
          : null,
      passStopList: PassStopList.fromJson(json['passStopList'] ?? {'stations': []}),
    );
  }
}

class TransitRoute {
  final RouteInfo info;
  final List<TransitSegment> subPath;

  TransitRoute({
    required this.info,
    required this.subPath,
  });

  factory TransitRoute.fromJson(Map<String, dynamic> json) {
    return TransitRoute(
      info: RouteInfo.fromJson(json['info']),
      subPath: (json['subPath'] as List? ?? [])
          .map((segment) => TransitSegment.fromJson(segment))
          .toList(),
    );
  }
}