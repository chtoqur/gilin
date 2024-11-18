import 'package:dio/dio.dart';
import '../../models/route/transit_route.dart';
import '../../state/route/route_state.dart';

class RouteService {
  final Dio _dio;
  static const String baseUrl = 'https://k11a306.p.ssafy.io/api';

  RouteService() : _dio = Dio();

  Future<TransitRoute> getRoute({
    required double sx,
    required double sy,
    required double ex,
    required double ey,
    required List<String> travelTypes,
    required DateTime? arrivalTime,
  }) async {
    try {
      print('Request Parameters:');
      print('sx: $sx, sy: $sy, ex: $ex, ey: $ey');
      print('travelTypes: $travelTypes');
      print('arrivalTime:  $arrivalTime');
      final response = await _dio.get(
        '$baseUrl/',
        queryParameters: {
          'sx': sx,
          'sy': sy,
          'ex': ex,
          'ey': ey,
          'travelTypes[]': travelTypes,
          'arrivalTime': arrivalTime?.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        print('\nAPI Response:');
        print('----------------------------------------');
        print(response.data);
        print('----------------------------------------');

        print('\nRoute Info:');
        print('Total Time: ${response.data['info']['totalTime']} minutes');
        print('Total Distance: ${response.data['info']['totalDistance']} meters');
        print('Payment: ${response.data['info']['payment']} won');

        print('\nSegment Details:');
        for (var segment in response.data['subPath']) {
          print('\nNew Segment:');
          print('Type: ${segment['travelType']}');
          print('Start: ${segment['startName']}');
          print('End: ${segment['endName']}');
          print('Distance: ${segment['distance']} meters');
          print('Time: ${segment['sectionTime']} minutes');

          if (segment['lane'] != null && segment['lane'].isNotEmpty) {
            print('Transportation Info:');
            for (var lane in segment['lane']) {
              print('  Name: ${lane['name']}');
              print('  Type: ${lane['type']}');
              if (lane['busNo'].toString().isNotEmpty) {
                print('  Bus Number: ${lane['busNo']}');
              }
              if (lane['subwayCode'] != 0) {
                print('  Subway Line: ${lane['subwayCode']}');
              }
            }
          }

          if (segment['pathGraph'] != null) {
            print('Path Points: ${segment['pathGraph'].length}');
          }
        }

        return TransitRoute.fromJson(response.data);
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      print('Error fetching route: $e');
      throw Exception('Error fetching route: $e');
    }
  }
}


