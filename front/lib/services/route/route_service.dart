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
        return TransitRoute.fromJson(response.data);
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      throw Exception('Error fetching route: $e');
    }
  }
}