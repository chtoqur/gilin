import 'package:gap/gap.dart'; // Gap import 추가
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/route/transit_route.dart';
import '../../models/search/local_search_result.dart';
import '../../models/route/custom_route.dart';

// 테스트용
import '../../utils/sample_data/route_samples.dart';
import '../../widgets/guide/sidebar.dart';

class GuidePreviewScreen extends ConsumerStatefulWidget {
  final LocalSearchResult selectedLocation;
  final TransitRoute routeData; // 백엔드에서 받은 경로 데이터

  const GuidePreviewScreen({
    Key? key,
    required this.selectedLocation,
    required this.routeData,
  }) : super(key: key);

  @override
  ConsumerState<GuidePreviewScreen> createState() => _GuidePreviewScreenState();
}

class _GuidePreviewScreenState extends ConsumerState<GuidePreviewScreen> {
  NaverMapController? mapController;
  NPathOverlay? pathOverlay;
  List<NMarker> markers = [];
  // ValueNotifier는 한 번만 선언
  final ValueNotifier<TransitSegment?> _selectedSegmentNotifier = ValueNotifier(null);

  // 헬퍼 메서드들을 클래스 상단에 배치
  IconData _getTransitIcon(TransitType type) {
    switch (type) {
      case TransitType.bus:
        return Icons.directions_bus;
      case TransitType.subway:
        return Icons.subway;
      case TransitType.taxi:
        return Icons.local_taxi;
      case TransitType.walking:
        return Icons.directions_walk;
      case TransitType.bicycle:
        return Icons.pedal_bike;
    }
  }

  String _getTransitTypeText(TransitType type) {
    switch (type) {
      case TransitType.bus:
        return '버스';
      case TransitType.subway:
        return '지하철';
      case TransitType.taxi:
        return '택시';
      case TransitType.walking:
        return '도보';
      case TransitType.bicycle:
        return '자전거';
    }
  }

  String _formatDistance(double meters) {
    return meters >= 1000
        ? '${(meters / 1000).toStringAsFixed(1)}km'
        : '${meters.toInt()}m';
  }

  Future<void> _initializeMapAndPath(NaverMapController controller) async {
    try {
      List<NLatLng> allCoordinates = [];
      for (var segment in widget.routeData.segments) {
        allCoordinates.addAll(segment.coordinates);
      }

      // 시작점과 도착점 좌표
      final startPoint = allCoordinates.first;
      final endPoint = allCoordinates.last;

      // 시작점 마커 생성
      final startMarker = NMarker(
        id: 'start_marker',
        position: startPoint,
        icon: NOverlayImage.fromAssetImage('assets/images/start_marker.png'),
      );

      // 도착점 마커 생성
      final endMarker = NMarker(
        id: 'end_marker',
        position: endPoint,
        icon: NOverlayImage.fromAssetImage('assets/images/end_marker.png'),
      );

      // InfoWindow 생성
      final startInfoWindow = NInfoWindow.onMarker(
        id: 'start_info',
        text: '시작점',
      );

      final endInfoWindow = NInfoWindow.onMarker(
        id: 'end_info',
        text: widget.selectedLocation.title,
      );

      // 마커와 InfoWindow 추가
      await controller.addOverlay(startMarker);
      await controller.addOverlay(endMarker);
      await startMarker.openInfoWindow(startInfoWindow);
      await endMarker.openInfoWindow(endInfoWindow);

      markers.addAll([startMarker, endMarker]);

      // 경로 오버레이 생성 및 추가
      pathOverlay = NPathOverlay(
        id: 'path_overlay',
        coords: allCoordinates,
        color: Colors.blue,
        width: 5,
        outlineColor: Colors.white,
        outlineWidth: 2,
        patternImage:
            NOverlayImage.fromAssetImage('assets/images/path_pattern.png'),
        patternInterval: 30,
      );

      await controller.addOverlay(pathOverlay!);

      // 경로가 모두 보이도록 카메라 이동
      final bounds = NLatLngBounds(
        southWest: NLatLng(
          allCoordinates
              .map((coord) => coord.latitude)
              .reduce((a, b) => a < b ? a : b),
          allCoordinates
              .map((coord) => coord.longitude)
              .reduce((a, b) => a < b ? a : b),
        ),
        northEast: NLatLng(
          allCoordinates
              .map((coord) => coord.latitude)
              .reduce((a, b) => a > b ? a : b),
          allCoordinates
              .map((coord) => coord.longitude)
              .reduce((a, b) => a > b ? a : b),
        ),
      );

      await controller.updateCamera(
        NCameraUpdate.fitBounds(
          bounds,
          padding: EdgeInsets.all(48),
        ),
      );
    } catch (e) {
      print('Error initializing map and path: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('경로를 표시하는 중 오류가 발생했습니다: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경로 미리보기'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              indoorEnable: true,
              locationButtonEnable: true,
              consumeSymbolTapEvents: false,
            ),
            onMapReady: (controller) {
              mapController = controller;
              _initializeMapAndPath(controller);
            },
          ),
          // 경로 정보 표시
          Positioned(
            left: 16,
            top: 16,
            child: ValueListenableBuilder<TransitSegment?>(
              valueListenable: _selectedSegmentNotifier,
              builder: (context, selectedSegment, child) {
                if (selectedSegment == null) return const SizedBox.shrink();

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getTransitIcon(selectedSegment.type),
                            color: const Color(0xFF8DA05D),
                          ),
                          const Gap(8),
                          Text(
                            _getTransitTypeText(selectedSegment.type),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      Text(
                        '${selectedSegment.startName} → ${selectedSegment.endName}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Gap(8),
                      Text(
                        '${_formatDistance(selectedSegment.distance)} • ${selectedSegment.duration}분',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 사이드바
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: GuideSidebar(
                routeData: widget.routeData,
                onSegmentTap: (TransitSegment segment) {
                  // TransitSegment를 받아서 처리
                  _selectedSegmentNotifier.value = segment;
                  // segment의 coordinates에서 첫 번째 좌표를 사용
                  mapController?.updateCamera(
                    NCameraUpdate.withParams(
                      target: segment.coordinates.first,
                      zoom: 17,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (mapController != null) {
      for (var marker in markers) {
        mapController?.deleteOverlay(marker.info);
      }
      if (pathOverlay != null) {
        mapController?.deleteOverlay(pathOverlay!.info);
      }
    }
    super.dispose();
  }
}
