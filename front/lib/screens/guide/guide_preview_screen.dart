import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../models/route/transit_route.dart';
import '../../state/route/route_state.dart';
import '../../widgets/guide/route_info_box.dart';
import '../../widgets/guide/sidebar.dart';
import '../../utils/guide/path_style_utils.dart';

class GuidePreviewScreen extends ConsumerStatefulWidget {
  final TransitRoute routeData;
  final RouteState routeState;

  const GuidePreviewScreen({
    Key? key,
    required this.routeData,
    required this.routeState,
  }) : super(key: key);

  @override
  ConsumerState<GuidePreviewScreen> createState() => _GuidePreviewScreenState();
}

class _GuidePreviewScreenState extends ConsumerState<GuidePreviewScreen> {
  NaverMapController? mapController;
  List<NPathOverlay> pathOverlays = []; // 여기에 추가
  List<NMarker> markers = [];
  final ValueNotifier<TransitSegment?> _selectedSegmentNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isSidebarVisible = ValueNotifier(true);

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

  String _formatDistance(double meters) {
    return meters >= 1000
        ? '${(meters / 1000).toStringAsFixed(1)}km'
        : '${meters.toInt()}m';
  }

  Future<void> _initializeMapAndPath(NaverMapController controller) async {
    try {
      List<NLatLng> allCoordinates = [];

      for (var segment in widget.routeData.subPath) {
        print('Creating overlay for segment type: ${segment.travelType}');

        final pathOverlay = PathStyleUtils.createPathOverlay(
          id: 'path_overlay_${widget.routeData.subPath.indexOf(segment)}',
          coords: segment.pathGraph,
          segment: segment,
        );
        await controller.addOverlay(pathOverlay);
        pathOverlays.add(pathOverlay);
        allCoordinates.addAll(segment.pathGraph);
      }

      final startPoint = NLatLng(widget.routeState.startPoint.y, widget.routeState.startPoint.x);
      final endPoint = NLatLng(widget.routeState.endPoint.y, widget.routeState.endPoint.x);

      final startMarker = NMarker(
        id: 'start_marker',
        position: startPoint,
        icon: NOverlayImage.fromAssetImage('assets/images/start_marker.png'),
      );

      final endMarker = NMarker(
        id: 'end_marker',
        position: endPoint,
        icon: NOverlayImage.fromAssetImage('assets/images/end_marker.png'),
      );

      final startInfoWindow = NInfoWindow.onMarker(
        id: 'start_info',
        text: widget.routeState.startPoint.title,
      );

      final endInfoWindow = NInfoWindow.onMarker(
        id: 'end_info',
        text: widget.routeState.endPoint.title,
      );

      await controller.addOverlay(startMarker);
      await controller.addOverlay(endMarker);
      await startMarker.openInfoWindow(startInfoWindow);
      await endMarker.openInfoWindow(endInfoWindow);

      markers.addAll([startMarker, endMarker]);

      // pathOverlay = NPathOverlay(
      //   id: 'path_overlay',
      //   coords: allCoordinates,
      //   color: Colors.blue,
      //   width: 5,
      //   outlineColor: Colors.white,
      //   outlineWidth: 2,
      //   patternImage:
      //       NOverlayImage.fromAssetImage('assets/images/path_pattern.png'),
      //   patternInterval: 30,
      // );


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
          // 인포박스
          Positioned(
            left: 16,
            top: 16,
            child: ValueListenableBuilder<TransitSegment?>(
              valueListenable: _selectedSegmentNotifier,
              builder: (context, selectedSegment, child) {
                return RouteInfoBox(
                  selectedSegment: selectedSegment,
                  routeInfo: widget.routeData.info,
                );
              },
            ),
          ),
          // 사이드바와 시작 버튼
          ValueListenableBuilder<bool>(
            valueListenable: _isSidebarVisible,
            builder: (context, isVisible, child) {
              return Positioned(
                right: isVisible ? 0 : -(MediaQuery.of(context).size.width * 0.25),
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: GuideSidebar(
                    routeData: widget.routeData,
                    onSegmentTap: (segment) {
                      _selectedSegmentNotifier.value = segment;
                      mapController?.updateCamera(
                        NCameraUpdate.withParams(
                          target: segment.pathGraph.first,
                          zoom: 17,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
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
      for (var overlay in pathOverlays) {  // 모든 경로 오버레이 제거
        mapController?.deleteOverlay(overlay.info);
      }
    }
    super.dispose();
  }
}
