import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/route/transit_route.dart';

class RouteInfoBox extends StatelessWidget {
  final TransitSegment? selectedSegment;
  final RouteInfo routeInfo;

  const RouteInfoBox({
    Key? key,
    this.selectedSegment,
    required this.routeInfo,
  }) : super(key: key);

  String _formatTime(int minutes) {
    if (minutes < 60) {
      return '$minutes분';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours시간 ${remainingMinutes}분';
  }

  String _getArrivalTime(int totalMinutes) {
    final now = DateTime.now();
    final arrival = now.add(Duration(minutes: totalMinutes));
    return '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')} 도착 예정';
  }

  String _formatDistance(double meters) {
    return meters >= 1000
        ? '${(meters / 1000).toStringAsFixed(1)}km'
        : '${meters.toInt()}m';
  }

  IconData _getTransitIcon(TransitType type) {
    switch (type) {
      case TransitType.BUS:
        return Icons.directions_bus;
      case TransitType.METRO:
        return Icons.subway;
      case TransitType.TAXI:
        return Icons.local_taxi;
      case TransitType.WALK:
        return Icons.directions_walk;
      case TransitType.BICYCLE:
        return Icons.pedal_bike;
    }
  }

  String _getTransitTypeText(TransitType type) {
    switch (type) {
      case TransitType.BUS:
        return '버스';
      case TransitType.METRO:
        return '지하철';
      case TransitType.TAXI:
        return '택시';
      case TransitType.WALK:
        return '도보';
      case TransitType.BICYCLE:
        return '자전거';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 170,
        maxWidth: 250,
        minHeight: 129,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFF8F5F0),
      ),
      child: selectedSegment == null
          ? _buildRouteOverview()
          : _buildSegmentDetail(selectedSegment!),
    );
  }

  Widget _buildRouteOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getArrivalTime(routeInfo.totalTime),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Text(
          '소요시간: ${_formatTime(routeInfo.totalTime)}',
          style: const TextStyle(fontSize: 14),
        ),
        const Gap(8),
        Text(
          '요금: ${routeInfo.payment}원',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentDetail(TransitSegment segment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              _getTransitIcon(segment.travelType),
              color: const Color(0xFF8DA05D),
            ),
            const Gap(8),
            Text(
              _getTransitTypeText(segment.travelType),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Gap(12),
        Text(
          '${segment.startName} → ${segment.endName}',
          style: const TextStyle(fontSize: 14),
        ),
        const Gap(8),
        Text(
          '${_formatDistance(segment.distance)} • ${segment.sectionTime}분',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}