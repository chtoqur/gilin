import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteLocation {
  final String title;
  final double x;
  final double y;

  const RouteLocation({
    this.title = '',
    this.x = 0.0,
    this.y = 0.0,
  });

  RouteLocation copyWith({
    String? title,
    double? x,
    double? y,
  }) {
    return RouteLocation(
      title: title ?? this.title,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}

class RouteState {
  final RouteLocation startPoint;
  final RouteLocation endPoint;
  final RouteInputMode? currentInputMode;

  const RouteState({
    this.startPoint = const RouteLocation(),
    this.endPoint = const RouteLocation(),
    this.currentInputMode,
  });

  RouteState copyWith({
    RouteLocation? startPoint,
    RouteLocation? endPoint,
    RouteInputMode? currentInputMode,
  }) {
    return RouteState(
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      currentInputMode: currentInputMode ?? this.currentInputMode,
    );
  }
}

enum RouteInputMode { start, end }

class RouteNotifier extends StateNotifier<RouteState> {
  RouteNotifier() : super(const RouteState());

  void setInputMode(RouteInputMode mode) {
    state = state.copyWith(currentInputMode: mode);
  }

  void setLocation(String title, double x, double y) {
    if (state.currentInputMode == RouteInputMode.start) {
      state = state.copyWith(
        startPoint: RouteLocation(title: title, x: x, y: y),
        currentInputMode: null,
      );
    } else if (state.currentInputMode == RouteInputMode.end) {
      state = state.copyWith(
        endPoint: RouteLocation(title: title, x: x, y: y),
        currentInputMode: null,
      );
    }
  }

  void swapLocations() {
    state = state.copyWith(
      startPoint: state.endPoint,
      endPoint: state.startPoint,
    );
  }
}

final routeProvider = StateNotifierProvider<RouteNotifier, RouteState>((ref) {
  return RouteNotifier();
});