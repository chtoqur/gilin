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
    String? address,
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
  final DateTime? arrivalTime;
  final List<String> selectedTransports;
  final String? currentScreen;

  RouteState({
    this.startPoint = const RouteLocation(),
    this.endPoint = const RouteLocation(),
    this.currentInputMode,
    DateTime? arrivalTime,
    this.selectedTransports = const ['지하철', '버스', '도보'],
    this.currentScreen,
  }) : arrivalTime = arrivalTime ?? _initializeTime();

  static DateTime _initializeTime() {
    var now = DateTime.now();
    now = now.add(const Duration(hours: 9));
    var roundedMinutes = (now.minute ~/ 5) * 5;
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      roundedMinutes,
    );
  }

  RouteState copyWith({
    RouteLocation? startPoint,
    RouteLocation? endPoint,
    RouteInputMode? currentInputMode,
    DateTime? arrivalTime,
    List<String>? selectedTransports,
    String? currentScreen,
  }) {
    return RouteState(
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      currentInputMode: currentInputMode ?? this.currentInputMode,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      selectedTransports: selectedTransports ?? this.selectedTransports,
      currentScreen: currentScreen ?? this.currentScreen,
    );
  }
}

enum RouteInputMode { start, end }

class RouteNotifier extends StateNotifier<RouteState> {
  RouteNotifier() : super(RouteState());

  void setInputMode(RouteInputMode mode) {
    state = state.copyWith(currentInputMode: mode);
  }

  void setLocation(String title, double x, double y) {
    if (state.currentInputMode == RouteInputMode.start) {
      state = state.copyWith(
        startPoint: RouteLocation(title: title, x: x, y: y),
        currentInputMode: null,
        currentScreen: null,
      );
    } else if (state.currentInputMode == RouteInputMode.end) {
      state = state.copyWith(
        endPoint: RouteLocation(title: title, x: x, y: y),
        currentInputMode: null,
        currentScreen: null,
      );
    }
  }

  void setArrivalTime(DateTime time) {
    state = state.copyWith(arrivalTime: time);
  }

  void updateTransports(List<String> transports) {
    state = state.copyWith(selectedTransports: transports);
  }

  void swapLocations() {
    state = state.copyWith(
      startPoint: state.endPoint,
      endPoint: state.startPoint,
    );
  }

  void setCurrentScreen(String screen) {
    state = state.copyWith(currentScreen: screen);
  }
}

final routeProvider = StateNotifierProvider<RouteNotifier, RouteState>((ref) {
  return RouteNotifier();
});