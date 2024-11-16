import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final Map<String, NPathOverlay> _activeOverlays = {};
  List<NMarker> markers = [];
  final ValueNotifier<TransitSegment?> _selectedSegmentNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isSidebarVisible = ValueNotifier(true);
  Timer? _debounceTimer;

  Future<void> _safeDeleteOverlay(String id) async {
    try {
      final overlay = _activeOverlays[id];
      if (overlay != null) {
        await mapController?.deleteOverlay(overlay.info);
        _activeOverlays.remove(id);
      }
    } catch (e) {
      print('Failed to delete overlay $id: $e');
    }
  }

  // 새로운 메서드: 오버레이 추가를 위한 안전한 방법
  Future<void> _safeAddOverlay(NPathOverlay overlay) async {
    try {
      await mapController?.addOverlay(overlay);
      _activeOverlays[overlay.info.id] = overlay;
    } catch (e) {
      print('Failed to add overlay ${overlay.info.id}: $e');
    }
  }

  Future<void> _refreshPathOverlays(double zoomLevel) async {
    // 기존 오버레이 제거
    final overlayIds = [..._activeOverlays.keys];
    for (var id in overlayIds) {
      await _safeDeleteOverlay(id);
    }

    // 새 오버레이 생성 및 추가
    for (var segment in widget.routeData.subPath) {
      final overlays = PathStyleUtils.createPathOverlay(
        id: 'path_overlay_${widget.routeData.subPath.indexOf(segment)}',
        coords: segment.pathGraph,
        segment: segment,
        zoomLevel: zoomLevel,
      );

      for (var overlay in overlays) {
        await _safeAddOverlay(overlay);
      }
    }
  }

  void _onMapZoomChanged() {
    // 이전 타이머 취소
    _debounceTimer?.cancel();

    // 새로운 타이머 시작 (300ms 딜레이)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (mapController == null) return;

      try {
        final cameraPosition = await mapController!.getCameraPosition();
        await _refreshPathOverlays(cameraPosition.zoom);
      } catch (e) {
        print('Error updating overlays: $e');
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    for (var overlay in _activeOverlays.values) {
      try {
        mapController?.deleteOverlay(overlay.info);
      } catch (e) {
        print('Failed to delete overlay on dispose: $e');
      }
    }
    for (var marker in markers) {
      mapController?.deleteOverlay(marker.info);
    }
    super.dispose();
  }

  Future<void> _initializeMapAndPath(NaverMapController controller) async {
    try {
      List<NLatLng> allCoordinates = [];

      // 현재 줌 레벨 가져오기
      final cameraPosition = await controller.getCameraPosition();
      final zoomLevel = cameraPosition.zoom;

      // 경로 오버레이 생성
      await _refreshPathOverlays(zoomLevel);

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

      // bounds 계산을 위한 모든 좌표 수집
      for (var segment in widget.routeData.subPath) {
        allCoordinates.addAll(segment.pathGraph);
      }

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
            onCameraChange: (reason, animated) {
              if (reason == NCameraUpdateReason.gesture) {
                _onMapZoomChanged();
              }
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
                  transitRoute: widget.routeData,  // 추가된 부분
                );
              },
            ),
          ),          // 사이드바와 시작 버튼
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
  //
  // @override
  // void dispose() {
  //   if (mapController != null) {
  //     for (var marker in markers) {
  //       mapController?.deleteOverlay(marker.info);
  //     }
  //     for (var overlay in pathOverlays) {  // 모든 경로 오버레이 제거
  //       mapController?.deleteOverlay(overlay.info);
  //     }
  //   }
  //   super.dispose();
  // }
}
