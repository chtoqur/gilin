import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class TransitArrivalInfo {
  final String? vehicleName;
  final int arrivalTime;
  final int? remainingStops;
  final String? destination;

  TransitArrivalInfo({
    this.vehicleName,
    required this.arrivalTime,
    this.remainingStops,
    this.destination,
  });
}

class MetroPositionInfo {
  final String stationName;
  final String line;
  final String trainLineNm;
  final String trainNo;
  final String status;

  MetroPositionInfo({
    required this.stationName,
    required this.line,
    required this.trainLineNm,
    required this.trainNo,
    required this.status,
  });

  factory MetroPositionInfo.fromJson(Map<String, dynamic> json) {
    return MetroPositionInfo(
      stationName: json['stationName'] ?? '',
      line: json['line'] ?? '',
      trainLineNm: json['trainLineNm'] ?? '',
      trainNo: json['trainNo'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class TransitService {
  final Dio _dio;
  static const String baseUrl = 'https://k11a306.p.ssafy.io/api';

  TransitService(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  String _prettyPrintJson(json) {
    var encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  // 지하철 예정 정보
  Future<List<TransitArrivalInfo>> getMetroArrival({
    required String stationName,
    required String nextStationName,
  }) async {
      try {
        debugPrint('\n====== Metro API Request ======');
        debugPrint('Station: $stationName');
        debugPrint('Next Station: $nextStationName');

        var response = await _dio.get('/metro/station/arrival',
            queryParameters: {
              'stationName': stationName,
              'nextStationName': nextStationName,
            }
        );

        debugPrint('\n====== Metro API Response ======');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Data: ${_prettyPrintJson(response.data)}');

        if (response.data is List) {
          var dataList = response.data as List;
          return dataList.map((data) =>
              TransitArrivalInfo(
                vehicleName: data['trainNo'] as String?,
                arrivalTime: (data['time'] as num).toInt(),
                destination: data['trainLineNm'] as String?,
              )).toList();
        } else if (response.data is Map) {
          var data = response.data as Map<String, dynamic>;
          return [
            TransitArrivalInfo(
              vehicleName: data['trainNo'] as String?,
              arrivalTime: (data['time'] as num).toInt(),
              destination: data['trainLineNm'] as String?,
            )
          ];
        }

        return [];
      } catch (e, stackTrace) {
        debugPrint('\n====== Metro API Error ======');
        debugPrint('Error: $e');
        debugPrint('Stack trace: $stackTrace');
        return [];
      }
    }

    // 지하철 현재 위치
  Future<MetroPositionInfo?> getMetroPosition({
    required String trainNo,
    required String lineName,
  }) async {
    try {
      debugPrint('\n====== Metro Position API Request ======');
      debugPrint('Train No: $trainNo');
      debugPrint('Line Name: $lineName');

      var response = await _dio.get('/metro/pos',
          queryParameters: {
            'trainNo': trainNo,
            'lineName': lineName,
          }
      );

      debugPrint('\n====== Metro Position API Response ======');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Data: ${_prettyPrintJson(response.data)}');

      if (response.statusCode == 200) {
        return MetroPositionInfo.fromJson(response.data);
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('\n====== Metro Position API Error ======');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  // 버스 도착 예정 정보
    Future<List<TransitArrivalInfo>> getBusArrival({
      required String stationId,
      required String arsId,
      required List<String> routeIds,
    }) async {
      try {
        debugPrint('\n====== Bus API Request ======');
        debugPrint('Station ID: $stationId');
        debugPrint('ARS ID: $arsId');
        debugPrint('Route IDs: $routeIds');

        var response = await _dio.get(
            'https://k11a306.p.ssafy.io/api/arrivalTime',
            queryParameters: {
              'stationId': stationId,
              'arsId': arsId,
              'routeIds[]': routeIds, // 배열 파라미터 형식 수정
            }
        );

        debugPrint('\n====== Bus API Response ======');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Headers: ${response.headers}');
        debugPrint('Data: ${_prettyPrintJson(response.data)}');
        debugPrint('==============================\n');

        if (response.data is List) {
          var dataList = response.data as List;
          return dataList.map((data) =>
              TransitArrivalInfo(
                vehicleName: data['busName'] as String?,
                arrivalTime: (data['predictTimeSecond'] as num).toInt(),
                remainingStops: (data['remainStation'] as num?)?.toInt(),
              )).toList();
        }

        return [];
      } catch (e, stackTrace) {
        debugPrint('\n====== Bus API Error ======');
        debugPrint('Error: $e');
        debugPrint('Stack trace: $stackTrace');
        debugPrint('==========================\n');
        return [];
      }
    }
  }