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
  final RouteLocation homePoint;
  final RouteLocation companyPoint;
  final RouteLocation schoolPoint;
  final String? selectedWidget;

  LocationState({
    this.homePoint = const RouteLocation(),
    this.companyPoint = const RouteLocation(),
    this.schoolPoint = const RouteLocation(),
    this.selectedWidget,
  });

  LocationState copyWith({
    RouteLocation? homePoint,
    RouteLocation? companyPoint,
    RouteLocation? schoolPoint,
    String? selectedWidget,
  }) {
    return LocationState(
      homePoint: homePoint ?? this.homePoint,
      companyPoint: companyPoint ?? this.companyPoint,
      schoolPoint: schoolPoint ?? this.schoolPoint,
      selectedWidget: selectedWidget ?? this.selectedWidget,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  void setSelectedWidget(String widget) {
    state = state.copyWith(selectedWidget: widget);
  }

  void updateLocation(String title, double x, double y, String address) {
    switch (state.selectedWidget) {
      case 'home':
        state = state.copyWith(
          homePoint: RouteLocation(
            title: title,
            x: x,
            y: y,
            address: address,
          ),
        );
        break;
      case 'company':
        state = state.copyWith(
          companyPoint: RouteLocation(
            title: title,
            x: x,
            y: y,
            address: address,
          ),
        );
        break;
      case 'school':
        state = state.copyWith(
          schoolPoint: RouteLocation(
            title: title,
            x: x,
            y: y,
            address: address,
          ),
        );
        break;
    }
  }
}

final locationsProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
