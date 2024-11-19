import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteLocation {
  final String title;
  final String address;
  final double x;
  final double y;

  const RouteLocation({
    this.title = '',
    this.address = '',
    this.x = 0.0,
    this.y = 0.0,
  });

  RouteLocation copyWith({
    String? title,
    String? address,
    double? x,
    double? y,
  }) {
    return RouteLocation(
      title: title ?? this.title,
      address: address ?? this.address,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}

class LocationState {
  final RouteLocation point;

  LocationState({
    this.point = const RouteLocation(),
  });

  LocationState copyWith({
    RouteLocation? point,
  }) {
    return LocationState(
      point: point ?? this.point,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  void updateLocation(String title, double x, double y, String address) {
    state = state.copyWith(
      point: RouteLocation(
        title: title,
        x: x,
        y: y,
        address: address,
      ),
    );
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
