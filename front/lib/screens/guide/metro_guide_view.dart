import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../models/route/transit_route.dart';
import '../../state/guide/transit_provider.dart';
import '../../themes/path_color.dart';
import '../../services/guide/transit_service.dart';

// Metro Position Provider
final metroPositionProvider = StreamProvider.autoDispose.family<String, ({String trainNo, String lineName})>(
        (ref, params) async* {
      final transitService = ref.watch(transitServiceProvider);
      while (true) {
        final position = await transitService.getMetroPosition(
          trainNo: params.trainNo,
          lineName: params.lineName,
        );
        yield position?.stationName ?? '';
        await Future.delayed(const Duration(seconds: 15));
      }
    }
);

class MetroGuideView extends ConsumerStatefulWidget {
  final TransitSegment metroSegment;
  final String selectedTrainNo;

  const MetroGuideView({
    Key? key,
    required this.metroSegment,
    required this.selectedTrainNo,
  }) : super(key: key);

  @override
  ConsumerState<MetroGuideView> createState() => _MetroGuideViewState();
}

class _MetroGuideViewState extends ConsumerState<MetroGuideView> {
  final ScrollController _scrollController = ScrollController();
  double _trainPosition = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentStation();
    });
  }

  void _scrollToCurrentStation() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _trainPosition * 100, // 위치에 따른 스크롤 계산
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stations = widget.metroSegment.passStopList.stations;
    final subwayCode = widget.metroSegment.lane.first.subwayCode;
    final lineColor = PathColors.subwayColors[subwayCode] ?? PathColors.defaultSubwayColor;

    final currentStation = ref.watch(
        metroPositionProvider(
            (trainNo: widget.selectedTrainNo, lineName: widget.metroSegment.lane.first.name)
        )
    );

    // Info Box 데이터 계산
    final currentIndex = stations.indexWhere((s) => s.stationName == currentStation.value);
    final remainingStations = stations.length - currentIndex - 1;

    return Column(
      children: [
        // Info Box
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('현재 역: ${currentStation.value}'),
              const SizedBox(height: 8),
              Text('하차 역: ${stations.last.stationName}'),
              const SizedBox(height: 8),
              Text('남은 역: $remainingStations'),
            ],
          ),
        ),

        // Metro Line View
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: const EdgeInsets.only(left: 30), // 왼쪽 여백
              child: Stack(
                children: [
                  // Main Line
                  Container(
                    width: 8,
                    height: stations.length * 100.0, // 역 간 거리
                    color: lineColor,
                  ),

                  // Stations and Labels
                  ...List.generate(stations.length, (index) {
                    return Positioned(
                      left: 0,
                      top: index * 100.0,
                      child: Row(
                        children: [
                          // Station Node
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: lineColor, width: 3),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Station Name
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: lineColor),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              stations[index].stationName,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Train Position
                  if (currentStation.hasValue)
                    Positioned(
                      left: -8, // 선 중앙에 위치하도록 조정
                      top: currentIndex * 100.0,
                      child: Image.asset(
                        'assets/images/gilin_in_metro.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}