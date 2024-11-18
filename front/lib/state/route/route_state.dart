import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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
  final DateTime? arrivalTime;
  final List<String> selectedTransports;

  RouteState({
    RouteLocation? startPoint,
    this.endPoint = const RouteLocation(),
    this.currentInputMode,
    DateTime? arrivalTime,
    this.selectedTransports = const ['지하철', '버스', '도보'],
  }) :  startPoint = startPoint ?? const RouteLocation(),
        arrivalTime = arrivalTime ?? _initializeTime();

  static DateTime _initializeTime() { // 현재 시간으로 초기화
    var now = DateTime.now();
    var roundedMinutes = (now.minute ~/ 5) * 5;
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      roundedMinutes,
    );
  }

  static Future<RouteLocation> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return RouteLocation(
      title: '현재 위치',
      x: position.longitude,
      y: position.latitude,
    );
  }

  RouteState copyWith({
    RouteLocation? startPoint,
    RouteLocation? endPoint,
    RouteInputMode? currentInputMode,
    DateTime? arrivalTime,
    List<String>? selectedTransports,

  }) {
    return RouteState(
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      currentInputMode: currentInputMode ?? this.currentInputMode,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      selectedTransports: selectedTransports ?? this.selectedTransports,
    );
  }
}

enum RouteInputMode { start, end }

class RouteNotifier extends StateNotifier<RouteState> {
  RouteNotifier() : super(RouteState()) {
    _initializeStartPoint();
  }

  void _initializeStartPoint() async {
    var currentLocation = await RouteState.getCurrentLocation();
    state = state.copyWith(startPoint: currentLocation);
  }

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
}

final routeProvider = StateNotifierProvider<RouteNotifier, RouteState>((ref) {
  return RouteNotifier();
});