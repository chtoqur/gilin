import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/services/route/route_service.dart';

final routeServiceProvider = Provider<RouteService>((ref) {
  return RouteService();
});
