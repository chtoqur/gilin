import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../models/route/transit_route.dart';
import '../../themes/path_color.dart';
import '../../utils/guide/time_formatter.dart';
import '../../utils/guide/transit_utils.dart';

class RouteInfoBox extends StatelessWidget {
  final TransitSegment? selectedSegment;
  final RouteInfo routeInfo;
  final TransitRoute transitRoute; // 추가된 부분

  const RouteInfoBox({
    Key? key,
    this.selectedSegment,
    required this.routeInfo,
    required this.transitRoute, // 추가된 부분
  }) : super(key: key);

  Widget _buildBusSegment(TransitSegment segment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          segment.startName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '정류장 승차',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const Gap(8),
        Wrap(
          spacing: 8,
          children: segment.lane.map((lane) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: PathColors.busColors[lane.type] ??
                    PathColors.defaultBusColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                lane.busNo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
        const Gap(8),
        Text(
          '${segment.sectionTime}분, ${segment.stationCount}개 정류장 이동',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const Gap(8),
        Text(
          segment.endName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '정류장 하차',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSubwaySegment(TransitSegment segment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ...segment.lane.map((lane) {
              return Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PathColors.subwayColors[lane.subwayCode] ??
                      PathColors.defaultSubwayColor,
                ),
                child: Center(
                  child: Text(
                    lane.subwayCode.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            Expanded(
              child: Text(
                '${segment.startName} 승차',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Gap(8),
        Text(
          '${segment.sectionTime}분, ${segment.stationCount}역 이동',
          style: const TextStyle(fontSize: 14),
        ),
        const Gap(8),
        Text(
          '${segment.endName} 하차',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (segment.door != null) ...[
          const Gap(4),
          Text(
            '빠른 하차 ${segment.door}',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWalkSegment(TransitSegment segment) {
    if (selectedSegment == null) return const SizedBox.shrink();

    final currentIndex = transitRoute.subPath.indexOf(segment);
    final nextSegment = currentIndex < transitRoute.subPath.length - 1
        ? transitRoute.subPath[currentIndex + 1]
        : null;
    final prevSegment = currentIndex > 0
        ? transitRoute.subPath[currentIndex - 1]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (nextSegment?.travelType == TransitType.BUS)
          Text(
            '${nextSegment?.startName}까지',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        else
          if (nextSegment?.travelType == TransitType.METRO)
            Row(
              children: [
                Text(
                  '${nextSegment?.startName} ',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (segment.startExitNo != null) Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      segment.startExitNo!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text(
                  '번 출구까지',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            )
          else
            if (prevSegment?.travelType == TransitType.METRO &&
                segment.endExitNo != null)
              Text(
                '${segment.endExitNo}번 출구로 나와서',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
        const Gap(8),
        Text(
          '${segment.sectionTime}분, ${DistanceFormatter.format(
              segment.distance)} 걷기',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSegmentDetail(TransitSegment segment) {
    switch (segment.travelType) {
      case TransitType.BUS:
        return _buildBusSegment(segment);
      case TransitType.METRO:
        return _buildSubwaySegment(segment);
      case TransitType.WALK:
        return _buildWalkSegment(segment);
      case TransitType.BICYCLE:
        return _buildBicycleSegment(segment);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBicycleSegment(TransitSegment segment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '자전거 이동',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Gap(8),
        Text(
          '${segment.sectionTime}분, ${DistanceFormatter.format(
              segment.distance)}',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
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
}
