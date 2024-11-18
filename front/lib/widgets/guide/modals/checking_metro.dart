// lib/widgets/guide/modals/checking_metro.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../models/route/transit_route.dart';
import '../../../screens/guide/guide_main_screen.dart';
import '../../../state/guide/guid_state.dart';
import '../../../state/guide/metro_provider.dart';
import '../../../services/guide/transit_service.dart';
import '../transit_schedule.dart';

final arrivalInfoProvider = StateNotifierProvider<ArrivalInfoNotifier, AsyncValue<List<TransitArrivalInfo>>>((ref) {
  return ArrivalInfoNotifier();
});

class ArrivalInfoNotifier extends StateNotifier<AsyncValue<List<TransitArrivalInfo>>> {
  ArrivalInfoNotifier() : super(const AsyncValue.loading());

  Future<void> fetchArrivals(TransitService service, String stationName, String nextStationName) async {
    try {
      state = const AsyncValue.loading();
      final arrivals = await service.getMetroArrival(
        stationName: stationName,
        nextStationName: nextStationName,
      );
      state = AsyncValue.data(arrivals);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class CheckingMetroModal extends ConsumerStatefulWidget {
  final String stationName;
  final String nextStationName;

  const CheckingMetroModal({
    Key? key,
    required this.stationName,
    required this.nextStationName,
  }) : super(key: key);

  @override
  ConsumerState<CheckingMetroModal> createState() => _CheckingMetroModalState();
}

class _CheckingMetroModalState extends ConsumerState<CheckingMetroModal> {
  Timer? _timer;
  TransitArrivalInfo? _selectedArrival;

  @override
  void initState() {
    super.initState();
    _fetchArrivals();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchArrivals();
    });
  }

  Future<void> _fetchArrivals() async {
    final transitService = ref.read(transitServiceProvider);
    await ref.read(arrivalInfoProvider.notifier).fetchArrivals(
      transitService,
      widget.stationName,
      widget.nextStationName,
    );
  }

  void _onConfirm() {
    if (_selectedArrival != null) {
      // 현재 metroSegment 찾기
      final guideMainScreen = context.findAncestorWidgetOfExactType<GuideMainScreen>();
      final metroSegment = guideMainScreen?.routeData.subPath.firstWhere(
            (segment) => segment.travelType == TransitType.METRO,
      );

      if (metroSegment != null) {
        // guideState 업데이트
        ref.read(guideStateProvider.notifier).setMetroGuideMode(
          isMetroGuide: true,
          metroSegment: metroSegment,
          selectedTrainNo: _selectedArrival!.vehicleName ?? '',
        );

        // 디버깅용 출력
        print('Updating GuideState:');
        print('trainNo: ${_selectedArrival!.vehicleName}');
        print('isMetroGuide: true');

        // 모달 닫기
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arrivalState = ref.watch(arrivalInfoProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '어떤 지하철을 타셨나요?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchArrivals,
              ),
            ],
          ),
          const SizedBox(height: 16),
          arrivalState.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('오류가 발생했습니다: $error'),
            data: (arrivals) {
              if (arrivals.isEmpty) {
                return const Text('도착 정보가 없습니다.');
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: arrivals.length,
                itemBuilder: (context, index) {
                  final arrival = arrivals[index];
                  final isSelected = _selectedArrival == arrival;

                  return RadioListTile<TransitArrivalInfo>(
                    value: arrival,
                    groupValue: _selectedArrival,
                    onChanged: (TransitArrivalInfo? value) {
                      setState(() => _selectedArrival = value);
                    },
                    title: Text('열차 번호: ${arrival.vehicleName}'),
                    subtitle: Text(
                      '도착 시간: ${arrival.arrivalTime}초 후\n'
                          '방향: ${arrival.destination}',
                    ),
                    selected: isSelected,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _selectedArrival != null ? _onConfirm : null,
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}