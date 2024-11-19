import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../models/route/transit_route.dart';
import '../../services/guide/transit_service.dart';
import '../../themes/path_color.dart';

final transitServiceProvider = Provider((ref) => TransitService(Dio()));

class TransitSchedule extends ConsumerStatefulWidget {
  final TransitSegment segment;
  final TransitType type;

  const TransitSchedule({
    Key? key,
    required this.segment,
    required this.type,
  }) : super(key: key);

  @override
  ConsumerState<TransitSchedule> createState() => _TransitScheduleState();
}

class _TransitScheduleState extends ConsumerState<TransitSchedule> {
  List<TransitArrivalInfo> arrivals = [];
  bool isLoading = true;
  String? errorMessage;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchArrivalInfo();
    // 15초마다 자동 갱신
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) {
        _fetchArrivalInfo();
      }
    });
  }

  @override
  void didUpdateWidget(TransitSchedule oldWidget) {
    super.didUpdateWidget(oldWidget);
    // segment가 변경되면 timer를 리셋하고 새로운 정보를 가져옴
    if (oldWidget.segment != widget.segment) {
      _refreshTimer?.cancel();
      _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        if (mounted) {
          _fetchArrivalInfo();
        }
      });
      _fetchArrivalInfo();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchArrivalInfo() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      var service = ref.read(transitServiceProvider);
      List<TransitArrivalInfo> result = [];

      if (widget.type == TransitType.METRO) {
        String nextStation = '';
        if (widget.segment.passStopList.stations.length > 1) {
          nextStation = widget.segment.passStopList.stations[1].stationName;
        }

        debugPrint(
            'Fetching metro arrivals for ${widget.segment.startName} to $nextStation');

        result = await service.getMetroArrival(
          stationName: widget.segment.startName,
          nextStationName: nextStation,
        );
      } else if (widget.type == TransitType.BUS) {
        var routeIds = widget.segment.lane.map((l) => l.busLocalBlID).toList();

        debugPrint(
            'Fetching bus arrivals for station ${widget.segment.startLocalStationID}');
        debugPrint('Route IDs: $routeIds');

        result = await service.getBusArrival(
          stationId: widget.segment.startLocalStationID,
          arsId: widget.segment.startArsID,
          routeIds: routeIds,
        );
      }

      if (mounted) {
        setState(() {
          arrivals = result;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching arrival info: $e');
      if (mounted) {
        setState(() {
          errorMessage = '도착 정보를 불러올 수 없습니다';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          errorMessage!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    if (arrivals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '도착 예정 정보가 없습니다',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(8),
        ...arrivals.map((info) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _buildArrivalInfo(info),
            )),
      ],
    );
  }

  Widget _buildArrivalInfo(TransitArrivalInfo info) {
    var minutes = (info.arrivalTime / 60).ceil();
    Widget timeWidget;

    if (minutes <= 0) {
      timeWidget = const Text(
        '곧 도착',
        style: TextStyle(
          fontSize: 13,
          color: Color(0xFFFDA868),
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      timeWidget = Text(
        '$minutes분',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // 지하철인 경우
    if (widget.type == TransitType.METRO) {
      return Row(
        children: [
          Icon(
            Icons.subway,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          timeWidget,
          if (info.destination != null) ...[
            const SizedBox(width: 4),
            Text(
              info.destination!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      );
    }

    // 버스인 경우
    return Row(
      children: [
        Icon(
          Icons.directions_bus,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: PathColors.busColors[widget.segment.lane
                .firstWhere(
                  (lane) => lane.busNo == info.vehicleName,
              orElse: () => widget.segment.lane.first,
            )
                .type] ?? PathColors.defaultBusColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            info.vehicleName ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        timeWidget,
        if (info.remainingStops != null) ...[
          const SizedBox(width: 4),
          Text(
            '(${info.remainingStops}정거장)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}