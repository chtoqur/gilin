import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/guide/tracking_provider.dart';
import 'package:gilin/widgets/shared/popup/confirm_boarding.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/route/transit_route.dart';
import '../../state/route/route_state.dart';
import '../../widgets/guide/route_info_box.dart';
import '../../widgets/guide/sidebar.dart';
import '../../utils/guide/path_style_utils.dart';

class GuideMainScreen extends ConsumerStatefulWidget {
  final TransitRoute routeData;
  final RouteState routeState;

  const GuideMainScreen({
    Key? key,
    required this.routeData,
    required this.routeState,
  }) : super(key: key);

  @override
  ConsumerState<GuideMainScreen> createState() => _GuideMainScreenState();
}

class _GuideMainScreenState extends ConsumerState<GuideMainScreen> {
  NaverMapController? mapController;
  final Map<String, NPathOverlay> _activeOverlays = {};
  List<NMarker> markers = [];
  final ValueNotifier<TransitSegment?> _selectedSegmentNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isSidebarVisible = ValueNotifier(true);
  Timer? _debounceTimer;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTrackingMode = true;
  bool _isInitialized = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _setupLocationTracking();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        ref.read(guideTrackingProvider.notifier).initializeTracking(widget.routeData);
        _isInitialized = true;
      }
    });
  }

  Future<void> _setupLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 서비스를 활성화해주세요.')),
        );
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('위치 권한이 거부되었습니다.')),
          );
        }
        return;
      }
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(_onLocationUpdate);
  }

  void _onLocationUpdate(Position position) async {
    if (!_isTrackingMode || mapController == null) return;

    var userLocation = NLatLng(position.latitude, position.longitude);
    var userBearing = position.heading;

    if (_isSidebarVisible.value) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      return;
    }

    await mapController!.updateCamera(
      NCameraUpdate.withParams(
        target: userLocation,
        zoom: 17,
        bearing: userBearing,
      ),
    );

    if (mounted) {
      Future.microtask(() {
        if (!mounted) return;

        // 1. 위치 근접 여부 확인
        ref.read(guideTrackingProvider.notifier).checkProximity(
          position.latitude,
          position.longitude,
        );

        // 2. 상태 기반 팝업 띄우기
        final trackingState = ref.read(guideTrackingProvider);
        if (trackingState.showAlert && _overlayEntry == null) {
          // 현재 추적 중인 세그먼트 정보를 팝업에 전달
          // _showBoardingAlert(trackingState.segments[trackingState.currentIndex]);
        }
      });
    }
  }


  Future<void> _safeAddOverlay(NPathOverlay overlay) async {
    try {
      await mapController?.addOverlay(overlay);
      _activeOverlays[overlay.info.id] = overlay;
    } catch (e) {
      print('Failed to add overlay ${overlay.info.id}: $e');
    }
  }

  Future<void> _initializeMapAndPath(NaverMapController controller) async {
    try {
      List<NLatLng> allCoordinates = [];

      // 경로 오버레이를 한 번만 생성
      for (var segment in widget.routeData.subPath) {
        var overlays = PathStyleUtils.createPathOverlay(
          id: 'path_overlay_${widget.routeData.subPath.indexOf(segment)}',
          coords: segment.pathGraph,
          segment: segment,
          zoomLevel: 17,
        );

        for (var overlay in overlays) {
          await _safeAddOverlay(overlay);
        }
      }

      // 시작점과 도착점 마커 설정
      var startPoint = NLatLng(widget.routeState.startPoint.y, widget.routeState.startPoint.x);
      var endPoint = NLatLng(widget.routeState.endPoint.y, widget.routeState.endPoint.x);

      var startMarker = NMarker(
        id: 'start_marker',
        position: startPoint,
        icon: const NOverlayImage.fromAssetImage('assets/images/start_marker.png'),
      );

      var endMarker = NMarker(
        id: 'end_marker',
        position: endPoint,
        icon: const NOverlayImage.fromAssetImage('assets/images/end_marker.png'),
      );

      await controller.addOverlay(startMarker);
      await controller.addOverlay(endMarker);
      markers.addAll([startMarker, endMarker]);

      for (var segment in widget.routeData.subPath) {
        allCoordinates.addAll(segment.pathGraph);
      }

      // 초기 위치 설정
      Position position = await Geolocator.getCurrentPosition();
      await controller.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(position.latitude, position.longitude),
          zoom: 17,
          bearing: position.heading,
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

  void _showBoardingAlert(TransitSegment segment) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: ConfirmBoardingPopup(
          transitType: segment.travelType.name,
          stationName: segment.startName,
          routeName: segment.travelType == TransitType.METRO
              ? segment.lane.first.name
              : segment.lane.first.busNo,
          onConfirm: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
            Future.microtask(() {
              ref.read(guideTrackingProvider.notifier).moveToNext();

              var trackingState = ref.read(guideTrackingProvider);
              if (trackingState.isTrackingEnd) {
                context.push('/route');
              }
            });
          },
          onCancel: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
            Future.microtask(() {
              ref.read(guideTrackingProvider.notifier).hideAlert();
            });
          },
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                setState(() {
                  _isTrackingMode = false;
                });
              }
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isSidebarVisible,
            builder: (context, isVisible, child) {
              return Stack(
                children: [
                  if (isVisible)
                    Positioned(
                      left: 16,
                      top: MediaQuery.of(context).padding.top + 16,
                      child: ValueListenableBuilder<TransitSegment?>(
                        valueListenable: _selectedSegmentNotifier,
                        builder: (context, selectedSegment, child) {
                          return RouteInfoBox(
                            selectedSegment: selectedSegment,
                            routeInfo: widget.routeData.info,
                            transitRoute: widget.routeData,
                          );
                        },
                      ),
                    ),
                  Positioned(
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
                          setState(() {
                            _isTrackingMode = false;
                          });
                        },
                        onClose: () async {
                          _isSidebarVisible.value = false;
                          setState(() {
                            _isTrackingMode = true;
                          });
                          var position = await Geolocator.getCurrentPosition();
                          await mapController?.updateCamera(
                            NCameraUpdate.withParams(
                              target: NLatLng(position.latitude, position.longitude),
                              zoom: 17,
                              bearing: position.heading,
                            ),
                          );
                        },
                        isGuideMode: true,
                        onGuideEnd: () => context.go('/route'),
                      ),
                    ),
                  ),
                  if (!isVisible)
                    Positioned(
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.4,
                      child: GestureDetector(
                        onTap: () {
                          _isSidebarVisible.value = true;
                          setState(() {
                            _isTrackingMode = false;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8DA05D),
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(-2, 0),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _positionStreamSubscription?.cancel();
    _overlayEntry?.remove();
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
}