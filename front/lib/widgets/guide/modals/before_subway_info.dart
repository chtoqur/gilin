import 'package:flutter/material.dart';
import '../../../models/route/transit_route.dart';
import '../../../state/guide/transit_provider.dart';
import '../../../themes/path_color.dart';
import '../../../services/guide/transit_service.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeforeSubwayInfo extends ConsumerStatefulWidget {
  final TransitSegment segment;

  const BeforeSubwayInfo({
    Key? key,
    required this.segment,
  }) : super(key: key);

  @override
  ConsumerState<BeforeSubwayInfo> createState() => _BeforeSubwayInfoState();
}

class _BeforeSubwayInfoState extends ConsumerState<BeforeSubwayInfo> {
  List<TransitArrivalInfo> arrivals = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchArrivalInfo();
  }

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

  Future<void> _fetchArrivalInfo() async {
    try {
      var service = ref.read(transitServiceProvider);
      String nextStation = '';
      if (widget.segment.passStopList.stations.length > 1) {
        nextStation = widget.segment.passStopList.stations[1].stationName;
      }

      final result = await service.getMetroArrival(
        stationName: widget.segment.startName,
        nextStationName: nextStation,
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
                // Station name with line numbers
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...widget.segment.lane.map((lane) {
                      return Container(
                        width: lane.subwayCode >= 100 ? 48 : 24,
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
                              fontSize: lane.subwayCode >= 100 ? 8 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                    Text(
                      '${widget.segment.startName}역',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                if (isLoading)
                  const CircularProgressIndicator(strokeWidth: 2)
                else if (errorMessage != null)
                  Text(errorMessage!, style: const TextStyle(color: Colors.red))
                else if (arrivals.isEmpty)
                    const Text('도착 예정 정보가 없습니다')
                  else
                    Column(
                      children: arrivals.map((info) {
                        final arrivalTime = DateTime.now().add(
                          Duration(seconds: info.arrivalTime),
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${arrivalTime.hour}:${arrivalTime.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${(info.arrivalTime / 60).floor()}분',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (info.destination != null) ...[
                                const Gap(4),
                                Text(
                                  info.destination!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                if (widget.segment.door != null && widget.segment.door != 'null') ...[
                  const Gap(16),
                  Text(
                    '빠른 하차 ${widget.segment.door}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}