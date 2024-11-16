// lib/services/transit/transit_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert'; // JSON 예쁘게 출력하기 위해 추가

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

class TransitService {
  final Dio _dio;

  TransitService(this._dio);

  String _prettyPrintJson(dynamic json) {
    var encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  Future<List<TransitArrivalInfo>> getMetroArrival({
    required String stationName,
    required String nextStationName,
  }) async {
    try {
      debugPrint('\n====== Metro API Request ======');
      debugPrint('Station: $stationName');
      debugPrint('Next Station: $nextStationName');
      debugPrint('Fetching metro arrival for $stationName to $nextStationName');

      final response = await _dio.get('https://k11a306.p.ssafy.io/api/metro/station/arrival',
          queryParameters: {
            'stationName': stationName,
            'nextStationName': nextStationName,
          }
      );

      debugPrint('\n====== Metro API Response ======');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Data: ${_prettyPrintJson(response.data)}');
      debugPrint('================================\n');

      if (response.data is List) {
        final dataList = response.data as List;
        return dataList.map((data) => TransitArrivalInfo(
          vehicleName: data['trainNo'] as String?,
          arrivalTime: (data['time'] as num).toInt(),
          destination: data['trainLineNm'] as String?,
        )).toList();
      } else if (response.data is Map) {
        final data = response.data as Map<String, dynamic>;
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
      debugPrint('============================\n');
      return [];
    }
  }

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

      final response = await _dio.get('https://k11a306.p.ssafy.io/api/arrivalTime',
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
        final dataList = response.data as List;
        return dataList.map((data) => TransitArrivalInfo(
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