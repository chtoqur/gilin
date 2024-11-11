import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/search/local_search_result.dart';
import '../../models/route/custom_route.dart';

// 테스트용
import '../../utils/sample_data/route_samples.dart';

class GuidePreviewScreen extends ConsumerStatefulWidget {
  final LocalSearchResult selectedLocation;
  final CustomRoute routeData; // 백엔드에서 받은 경로 데이터

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

  Future<void> _initializeMapAndPath(NaverMapController controller) async {
    try {
      // 시작점과 도착점 좌표
      final startPoint = widget.routeData.coordinates.first;
      final endPoint = widget.routeData.coordinates.last;

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
        coords: widget.routeData.coordinates,
        color: Colors.blue,
        width: 5,
        outlineColor: Colors.white,
        outlineWidth: 2,
        patternImage: NOverlayImage.fromAssetImage('assets/images/path_pattern.png'),
        patternInterval: 30,
      );

      await controller.addOverlay(pathOverlay!);

      // 경로가 모두 보이도록 카메라 이동
      final bounds = NLatLngBounds(
        southWest: NLatLng(
          widget.routeData.coordinates
              .map((coord) => coord.latitude)
              .reduce((a, b) => a < b ? a : b),
          widget.routeData.coordinates
              .map((coord) => coord.longitude)
              .reduce((a, b) => a < b ? a : b),
        ),
        northEast: NLatLng(
          widget.routeData.coordinates
              .map((coord) => coord.latitude)
              .reduce((a, b) => a > b ? a : b),
          widget.routeData.coordinates
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
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('총 거리'),
                        Text('${(widget.routeData.totalDistance / 1000).toStringAsFixed(1)}km'),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('예상 소요 시간'),
                        Text('${(widget.routeData.estimatedTime / 60).round()}분'),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('이동 수단'),
                        Text(widget.routeData.routeType),
                      ],
                    ),
                  ],
                ),
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