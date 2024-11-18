// lib/state/guide/guide_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/route/transit_route.dart';

class GuideState {
  final bool isMetroGuide;
  final TransitSegment? metroSegment;
  final String? selectedTrainNo;

  GuideState({
    this.isMetroGuide = false,
    this.metroSegment,
    this.selectedTrainNo,
  });

  GuideState copyWith({
    bool? isMetroGuide,
    TransitSegment? metroSegment,
    String? selectedTrainNo,
  }) {
    return GuideState(
      isMetroGuide: isMetroGuide ?? this.isMetroGuide,
      metroSegment: metroSegment ?? this.metroSegment,
      selectedTrainNo: selectedTrainNo ?? this.selectedTrainNo,
    );
  }
}

class GuideStateNotifier extends StateNotifier<GuideState> {
  GuideStateNotifier() : super(GuideState());

  void setMetroGuideMode({
    required bool isMetroGuide,
    TransitSegment? metroSegment,
    String? selectedTrainNo,
  }) {
    state = state.copyWith(
      isMetroGuide: isMetroGuide,
      metroSegment: metroSegment,
      selectedTrainNo: selectedTrainNo,
    );
  }
}

final guideStateProvider = StateNotifierProvider<GuideStateNotifier, GuideState>((ref) {
  return GuideStateNotifier();
});