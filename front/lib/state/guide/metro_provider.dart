// lib/state/guide/metro_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/guide/transit_service.dart';
import '../../widgets/guide/transit_schedule.dart';

class MetroState {
  final String trainNo;
  final String lineName;

  MetroState({
    required this.trainNo,
    required this.lineName,
  });

  MetroState copyWith({
    String? trainNo,
    String? lineName,
  }) {
    return MetroState(
      trainNo: trainNo ?? this.trainNo,
      lineName: lineName ?? this.lineName,
    );
  }
}

class MetroNotifier extends StateNotifier<MetroState> {
  MetroNotifier()
      : super(MetroState(trainNo: '', lineName: ''));

  void updateTrainInfo({
    required String trainNo,
    required String lineName,
  }) {
    state = state.copyWith(
      trainNo: trainNo,
      lineName: lineName,
    );
  }
}

final metroProvider = StateNotifierProvider<MetroNotifier, MetroState>((ref) {
  return MetroNotifier();
});

// 지하철 위치 정보를 위한 provider
final metroPositionProvider = FutureProvider.autoDispose.family<MetroPositionInfo?, MetroState>((ref, metroState) async {
  final transitService = ref.watch(transitServiceProvider);
  if (metroState.trainNo.isEmpty || metroState.lineName.isEmpty) {
    return null;
  }

  return await transitService.getMetroPosition(
    trainNo: metroState.trainNo,
    lineName: metroState.lineName,
  );
});