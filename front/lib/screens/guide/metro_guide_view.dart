import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../models/route/transit_route.dart';
import '../../state/guide/guid_state.dart';
import '../../state/guide/transit_provider.dart';
import '../../themes/path_color.dart';
import '../../services/guide/transit_service.dart';

final metroPositionProvider = StreamProvider.autoDispose.family<String, ({String trainNo, String lineName})>(
        (ref, params) async* {
      final transitService = ref.watch(transitServiceProvider);
      while (true) {
        final position = await transitService.getMetroPosition(
          trainNo: params.trainNo,
          lineName: params.lineName,
        );
        yield position?.stationName ?? '';
        await Future.delayed(const Duration(seconds: 1));
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
  int _lastIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  void _scrollToPosition(int index) {
    if (_scrollController.hasClients && _lastIndex != index) {
      _lastIndex = index;
      final targetPosition = index * 200.0;
      _scrollController.animateTo(
        targetPosition - (MediaQuery.of(context).size.height / 3),
        duration: const Duration(milliseconds: 300),
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

    final currentIndex = stations.indexWhere((s) => s.stationName == currentStation.value);
    final remainingStations = stations.length - currentIndex - 1;

    if (currentIndex >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToPosition(currentIndex);
      });
    }

    return Stack(
      children: [
        // Metro Line View
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              height: stations.length * 200.0,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main Line (centered)
                  Container(
                    width: 32,
                    height: double.infinity,
                    color: lineColor,
                  ),

                  // Station Nodes and Labels (fixed positions)
                  ...stations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final station = entry.value;

                    return Positioned(
                      top: index * 200.0,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Station circle overlaying the line
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: lineColor,
                                width: 12,
                              ),
                            ),
                          ),
                          // Station name (right of the circle)
                          Positioned(
                            left: MediaQuery.of(context).size.width / 2 + 50,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: lineColor),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                station.stationName,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Train Position (on top of everything)
                  if (currentStation.hasValue && currentIndex >= 0)
                    Positioned(
                      top: currentIndex * 200.0 - 24,
                      child: Image.asset(
                        'assets/images/guide/gilin_in_metro.png',
                        width: 128,
                        height: 128,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.train, size: 128);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Info Box
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('현재 역: ${currentStation.value}'),
                const SizedBox(height: 8),
                Text('하차 역: ${stations.last.stationName}'),
                const SizedBox(height: 8),
                Text('남은 역: $remainingStations'),
              ],
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