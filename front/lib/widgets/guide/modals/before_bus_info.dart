import 'package:flutter/material.dart';
import '../../../models/route/transit_route.dart';
import '../../../state/guide/transit_provider.dart';
import '../../../themes/path_color.dart';
import '../../../services/guide/transit_service.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeforeBusInfo extends ConsumerStatefulWidget {
  final TransitSegment segment;

  const BeforeBusInfo({
    Key? key,
    required this.segment,
  }) : super(key: key);

  @override
  ConsumerState<BeforeBusInfo> createState() => _BeforeBusInfoState();
}

class _BeforeBusInfoState extends ConsumerState<BeforeBusInfo> {
  bool _isExpanded = false;
  List<TransitArrivalInfo> arrivals = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchArrivalInfo();
  }

  Future<void> _fetchArrivalInfo() async {
    try {
      var service = ref.read(transitServiceProvider);
      var routeIds = widget.segment.lane.map((l) => l.busLocalBlID).toList();

      final result = await service.getBusArrival(
        stationId: widget.segment.startLocalStationID,
        arsId: widget.segment.startArsID,
        routeIds: routeIds,
      );

      if (mounted) {
        setState(() {
          arrivals = result;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = '도착 정보를 불러올 수 없습니다';
          isLoading = false;
        });
      }
    }
  }

  Widget _buildArrivalInfo(TransitArrivalInfo info) {
    final busType = widget.segment.lane.first.type;
    final busColor =
        PathColors.busColors[busType] ?? PathColors.defaultBusColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: busColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              info.vehicleName ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Gap(8),
          Text(
            '${(info.arrivalTime / 60).floor()}분',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (info.remainingStops != null) ...[
            const Gap(8),
            Text(
              '(${info.remainingStops}정류장)',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  widget.segment.startName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  '다음 정류장: ${widget.segment.passStopList.stations[1].stationName}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Gap(16),
                if (isLoading)
                  const CircularProgressIndicator(strokeWidth: 2)
                else if (errorMessage != null)
                  Text(errorMessage!, style: const TextStyle(color: Colors.red))
                else if (arrivals.isEmpty)
                  const Text('도착 예정 정보가 없습니다')
                else
                  Column(
                    children: [
                      _buildArrivalInfo(arrivals.first),
                      if (_isExpanded)
                        ...arrivals.skip(1).map(_buildArrivalInfo),
                    ],
                  ),
              ],
            ),
          ),
          if (arrivals.length > 1)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
