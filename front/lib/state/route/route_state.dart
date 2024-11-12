// route_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransportMode {
  walk,
  bicycle,
  bus,
  subway,
  taxi
}

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
  final Set<TransportMode> selectedTransportModes;

  const RouteState({
    this.startPoint = const RouteLocation(),
    this.endPoint = const RouteLocation(),
    this.currentInputMode,
    this.arrivalTime,
    this.selectedTransportModes = const {},
  });

  RouteState copyWith({
    RouteLocation? startPoint,
    RouteLocation? endPoint,
    RouteInputMode? currentInputMode,
    DateTime? arrivalTime,
    Set<TransportMode>? selectedTransportModes,
  }) {
    return RouteState(
      startPoint: startPoint ?? this.startPoint,
      endPoint: endPoint ?? this.endPoint,
      currentInputMode: currentInputMode ?? this.currentInputMode,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      selectedTransportModes: selectedTransportModes ?? this.selectedTransportModes,
    );
  }
}

enum RouteInputMode { start, end }

class RouteNotifier extends StateNotifier<RouteState> {
  RouteNotifier() : super(const RouteState());

  void setInputMode(RouteInputMode mode) {
    state = state.copyWith(currentInputMode: mode);
  }

  void setLocation(String title, double x, double y, {bool? isStart}) {
    if (isStart != null) {
      // isStart 파라미터가 제공된 경우
      if (isStart) {
        state = state.copyWith(
          startPoint: RouteLocation(title: title, x: x, y: y),
        );
      } else {
        state = state.copyWith(
          endPoint: RouteLocation(title: title, x: x, y: y),
        );
      }
    } else {
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
  }

  void setArrivalTime(DateTime time) {
    state = state.copyWith(arrivalTime: time);
  }

  void toggleTransportMode(TransportMode mode) {
    var currentModes = Set<TransportMode>.from(state.selectedTransportModes);
    if (currentModes.contains(mode)) {
      currentModes.remove(mode);
    } else {
      currentModes.add(mode);
    }
    state = state.copyWith(selectedTransportModes: currentModes);
    print('Updated transport modes: $currentModes'); // 디버깅용
  }

  void swapLocations() {
    state = state.copyWith(
      startPoint: state.endPoint,
      endPoint: state.startPoint,
    );
  }

  bool isReadyToStart() {
    return state.startPoint.title.isNotEmpty &&
           state.endPoint.title.isNotEmpty &&
           state.arrivalTime != null &&
           state.selectedTransportModes.isNotEmpty; // 최소 하나 이상의 이동수단이 선택되어 있어야 함
  }
}

final routeProvider = StateNotifierProvider<RouteNotifier, RouteState>((ref) {
  return RouteNotifier();
});

