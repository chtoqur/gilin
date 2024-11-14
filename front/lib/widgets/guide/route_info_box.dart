import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/route/transit_route.dart';
import '../../utils/guide/time_formatter.dart';
import '../../utils/guide/transit_utils.dart';

class RouteInfoBox extends StatelessWidget {
  final TransitSegment? selectedSegment;
  final RouteInfo routeInfo;

  const RouteInfoBox({
    Key? key,
    this.selectedSegment,
    required this.routeInfo,
  }) : super(key: key);


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
          TimeFormatter.formatArrivalTime(routeInfo.totalTime),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(12),
        Text(
          '소요시간: ${TimeFormatter.formatDuration(routeInfo.totalTime)}',
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
              TransitUtils.getTransitIcon(segment.travelType),
              color: const Color(0xFF8DA05D),
            ),
            const Gap(8),
            Text(
              TransitUtils.getTransitTypeText(segment.travelType),
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
          '${DistanceFormatter.format(segment.distance)} • ${segment.sectionTime}분',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}