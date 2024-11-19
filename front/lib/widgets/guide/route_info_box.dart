import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gilin/widgets/guide/transit_schedule.dart';
import '../../models/route/transit_route.dart';
import '../../themes/path_color.dart';
import '../../utils/guide/time_formatter.dart';

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
        const Text(
          '정류장 승차',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        TransitSchedule(
          segment: segment,
          type: TransitType.BUS,
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
        const Text(
          '정류장 하차',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSubwaySegment(TransitSegment segment) {
    var currentIndex = transitRoute.subPath.indexOf(segment);
    var prevSegment = currentIndex > 0 ? transitRoute.subPath[currentIndex - 1] : null;
    var isTransfer = prevSegment?.travelType == TransitType.TRANSFER;

    String getSubwayDisplay(int code) {
      switch (code) {
        case 116:
          return '수인분당';
        case 108:
          return '경춘';
        case 101:
          return '공항';
        case 109:
          return '신분당';
        default:
          return code.toString();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ...segment.lane.map((lane) {
              return Container(
                width: lane.subwayCode >= 100 ? 48 : 24,  // 특수 노선은 더 넓게                height: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PathColors.subwayColors[lane.subwayCode] ??
                      PathColors.defaultSubwayColor,
                ),
                child: Center(
                  child: Text(
                    getSubwayDisplay(lane.subwayCode),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: lane.subwayCode >= 100 ? 8 : 12,  // 특수 노선은 더 작게
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            Expanded(
              child: Text(
                '${segment.startName}역 ${isTransfer ? '환승' : '승차'}',  // 여기 수정
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        TransitSchedule(
          segment: segment,
          type: TransitType.METRO,
        ),
        const Gap(8),
        Text(
          '${segment.sectionTime}분, ${segment.stationCount}개역 이동',
          style: const TextStyle(fontSize: 14),
        ),
        const Gap(8),
        Text(
          '${segment.endName}역 하차',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (segment.door != null && segment.door != 'null') ...[
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

    var currentIndex = transitRoute.subPath.indexOf(segment);
    var nextSegment = currentIndex < transitRoute.subPath.length - 1
        ? transitRoute.subPath[currentIndex + 1]
        : null;
    var prevSegment = currentIndex > 0
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
        else if (nextSegment?.travelType == TransitType.METRO)
          Text(
            '${nextSegment?.startName}역까지',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        else if (prevSegment?.travelType == TransitType.METRO &&
              segment.endExitNo != null)
            Text(
              '${segment.endExitNo}번 출구로 나와서',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          else if (nextSegment == null)
              const Text(
                '목적지까지',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
        const Gap(8),
        Text(
          '${segment.sectionTime}분, ${DistanceFormatter.format(segment.distance)} 걷기',
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
        const Text(
          '자전거 이동',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
