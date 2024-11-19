import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/screens/route/route_screen.dart';
import 'package:gilin/widgets/guide/modals/tracking_popup.dart';
import 'package:gilin/widgets/shared/popup/confirm_popup.dart';
import 'package:gilin/widgets/shared/popup/confirm_popup_type.dart';
import 'package:gilin/widgets/shared/popup/taxi_info_popup.dart';
import 'package:gilin/widgets/shared/popup/warning_background.dart';
import 'package:go_router/go_router.dart';
import '../../models/route/transit_route.dart';
import '../../state/guide/guid_state.dart';
import '../../state/route/route_state.dart';
import '../../widgets/guide/modals/before_bus_info.dart';
import '../../widgets/guide/modals/before_subway_info.dart';
import '../../widgets/guide/route_info_box.dart';
import '../../widgets/guide/sidebar.dart';
import '../../utils/guide/path_style_utils.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/guide/modals/checking_metro.dart';
import 'metro_guide_view.dart';

class TrackingPoint {
  final TransitType travelType;
  final double x;
  final double y;
  final String? name;
  final String? lineInfo;

  TrackingPoint({
    required this.travelType,
    required this.x,
    required this.y,
    this.name,
    this.lineInfo,
  });

  @override
  String toString() {
    return 'TrackingPoint('
        'type: $travelType, '
        'x: $x, '
        'y: $y'
        '${name != null ? ', name: $name' : ''}'
        '${lineInfo != null ? ', lineInfo: $lineInfo' : ''}'
        ')';
  }
}

// ConsumerStatefulWidget 정의
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
  final ValueNotifier<TransitSegment?> _selectedSegmentNotifier =
      ValueNotifier(null);
  final ValueNotifier<bool> _isSidebarVisible = ValueNotifier(true);
  Timer? _debounceTimer;
  Timer? _trackingTimer;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTrackingMode = true;
  bool _isShowingBusInfo = false;
  bool _isShowingSubwayInfo = false;
  List<TrackingPoint> trackingPoints = [];
  int currentTrackingIndex = 0;
  bool _isProcessingPoint = false;
  bool _showingPopup = false;
  final warningPopupVisibilityProvider = StateProvider<bool>((ref) => false);
  final taxiPopupVisibilityProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    _setupTrackingPoints();
    _setupLocationTracking();
    _startTrackingTimer();

    final metroSegment = widget.routeData.subPath.firstWhere(
      (segment) => segment.travelType == TransitType.METRO,
      orElse: () => widget.routeData.subPath.first,
    );

    if (metroSegment.travelType == TransitType.METRO &&
        metroSegment.passStopList.stations.length > 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showModalBottomSheet(
            context: context,
            builder: (context) => CheckingMetroModal(
              stationName: metroSegment.startName,
              nextStationName:
                  metroSegment.passStopList.stations[1].stationName,
              routeData: widget.routeData,
            ),
          );
        }
      });
    }

    print('=== Tracking Points ===');
    for (var i = 0; i < trackingPoints.length; i++) {
      print('Point $i: ${trackingPoints[i]}');
    }
    print('=====================');
  }

  void _startTrackingTimer() {
    _trackingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (_isProcessingPoint) return;

      Position position = await Geolocator.getCurrentPosition();
      _checkCurrentTrackingPoint(position);
    });
  }

  Future<void> _checkCurrentTrackingPoint(Position userPosition) async {
    if (currentTrackingIndex >= trackingPoints.length || _showingPopup) return;

    _isProcessingPoint = true;

    try {
      var currentPoint = trackingPoints[currentTrackingIndex];
      var distance = await Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          currentPoint.y,
          currentPoint.x
      );

      print('=== Location Check ===');
      print('Distance: ${distance.toStringAsFixed(2)}m');

      if (distance <= 100 && !_showingPopup) {
        setState(() => _showingPopup = true);
        _showTrackingPopup(currentPoint);
      }
    } finally {
      _isProcessingPoint = false;
    }
  }

  void _showTrackingPopup(TrackingPoint point) {
    setState(() {
      _overlayEntry = OverlayEntry(
        builder: (context) => Consumer(
          builder: (context, ref, child) {
            final isWarningVisible = ref.watch(warningPopupVisibilityProvider);
            final isTaxiVisible = ref.watch(taxiPopupVisibilityProvider);

            return Stack(
              children: [
                TrackingPopup(
                  travelType: point.travelType,
                  name: point.name,
                  lineInfo: point.lineInfo,
                  onConfirm: () {
                    setState(() {
                      _showingPopup = false;
                      currentTrackingIndex++;
                    });
                    _overlayEntry?.remove();
                    _overlayEntry = null;

                    if (currentTrackingIndex == trackingPoints.length - 1) {
                      _showDestinationReachedDialog();
                    }
                  },
                  onCancel: () {
                    // 경고 팝업 표시
                    ref.read(warningPopupVisibilityProvider.notifier).state = true;
                  },
                ),
                if (isWarningVisible) ...[
                  WarningBackground(
                    child: Container(),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 60,
                    left: 40,
                    right: 40,
                    child: ConfirmPopupWidget(
                      popupType: PopupType.warningLate,
                      onConfirmPressed: () {
                        // 경고 팝업 닫기
                        ref.read(warningPopupVisibilityProvider.notifier).state = false;
                        // 기존 팝업 닫기
                        setState(() => _showingPopup = false);
                        _overlayEntry?.remove();
                        _overlayEntry = null;

                        // 현재 필요한 데이터 미리 가져오기
                        final startPointTitle = ref.read(routeProvider).startPoint.title;
                        final arrivalTime = ref.read(routeProvider).arrivalTime;

                        // 택시 팝업 생성
                        _overlayEntry = OverlayEntry(
                          builder: (BuildContext overlayContext) => Stack(
                            children: [
                              Positioned(
                                top: MediaQuery.of(overlayContext).padding.top + 60,
                                left: 20,
                                right: 20,
                                child: Material(  // Material 위젯의 위치 변경
                                  type: MaterialType.transparency,
                                  child: TaxiInfoPopup(
                                    location: startPointTitle,
                                    estimatedTime: _formatTime(arrivalTime),
                                    estimatedCost: 5700,
                                    onClose: () {
                                      setState(() {
                                        _overlayEntry?.remove();
                                        _overlayEntry = null;
                                        _showingPopup = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        // 새로운 오버레이 삽입
                        if (mounted) {
                          Overlay.of(context).insert(_overlayEntry!);
                        }
                      },
                      onCancelPressed: () {
                        // 경고 팝업만 닫기
                        ref.read(warningPopupVisibilityProvider.notifier).state = false;
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      );
    });

    Overlay.of(context).insert(_overlayEntry!);
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    String period = time.hour < 12 ? '오전' : '오후';
    int hour = time.hour <= 12 ? time.hour : time.hour - 12;
    return '$period $hour시 ${time.minute}분';
  }

  // 목적지 도착 모달
  void _showDestinationReachedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ConfirmPopupWidget(
            popupType: PopupType.arrivalCheck,
            onConfirmPressed: () {
              context.push('/success');
            },
            onCancelPressed: () {
              context.push('/failure');
            },
          ),
        );
      },
    );
  }

  void _setupTrackingPoints() {
    for (var segment in widget.routeData.subPath) {
      switch (segment.travelType) {
        case TransitType.METRO:
          trackingPoints.add(TrackingPoint(
            travelType: TransitType.METRO,
            x: segment.startX,
            y: segment.startY,
            name: segment.startName,
            lineInfo: segment.lane.isNotEmpty ? segment.lane.first.name : null,
          ));
          break;

        case TransitType.BUS:
          trackingPoints.add(TrackingPoint(
            travelType: TransitType.BUS,
            x: segment.startX,
            y: segment.startY,
            name: segment.startName,
            lineInfo: segment.lane.isNotEmpty ? segment.lane.first.busNo : null,
          ));
          break;

        case TransitType.WALK:
          trackingPoints.add(TrackingPoint(
            travelType: TransitType.WALK,
            x: segment.startX,
            y: segment.startY,
          ));
          trackingPoints.add(TrackingPoint(
            travelType: TransitType.WALK,
            x: segment.endX,
            y: segment.endY,
          ));
          break;

        default:
          break;
      }
    }
  }

  TransitSegment? _findNextTransitSegment(TransitType type) {
    for (int i = 0; i < widget.routeData.subPath.length; i++) {
      if (widget.routeData.subPath[i].travelType == type) {
        return widget.routeData.subPath[i];
      }
    }
    return null;
  }

  TransitSegment? _findNextBusSegment() {
    for (int i = 0; i < widget.routeData.subPath.length; i++) {
      if (widget.routeData.subPath[i].travelType == TransitType.BUS) {
        return widget.routeData.subPath[i];
      }
    }
    return null;
  }

  Future<void> _setupLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
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

    var nextSubwaySegment = _findNextTransitSegment(TransitType.METRO);

    if (nextSubwaySegment != null && !_isShowingSubwayInfo) {
      var subwayStationLocation = nextSubwaySegment.pathGraph.first;
      var distance = await Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          subwayStationLocation.latitude,
          subwayStationLocation.longitude);

      if (distance <= 200) {
        setState(() => _isShowingSubwayInfo = true);
        await showModalBottomSheet(
          context: context,
          builder: (context) => BeforeSubwayInfo(segment: nextSubwaySegment),
        ).whenComplete(() => setState(() => _isShowingSubwayInfo = false));
      }
    }

    var nextBusSegment = _findNextBusSegment();

    if (nextBusSegment != null && !_isShowingBusInfo) {
      var busStopLocation = nextBusSegment.pathGraph.first;
      var distance = await Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          busStopLocation.latitude,
          busStopLocation.longitude);

      if (distance <= 100) {
        setState(() => _isShowingBusInfo = true);
        await showModalBottomSheet(
          context: context,
          builder: (context) => BeforeBusInfo(segment: nextBusSegment),
        ).whenComplete(() => setState(() => _isShowingBusInfo = false));
      }
    }

    if (_isSidebarVisible.value) return;

    await mapController!.updateCamera(
      NCameraUpdate.withParams(
        target: userLocation,
        zoom: 17,
        bearing: position.heading,
      ),
    );
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

      var startPoint = NLatLng(
          widget.routeState.startPoint.y, widget.routeState.startPoint.x);
      var endPoint =
          NLatLng(widget.routeState.endPoint.y, widget.routeState.endPoint.x);

      for (var segment in widget.routeData.subPath) {
        allCoordinates.addAll(segment.pathGraph);
      }

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

  @override
  Widget build(BuildContext context) {
    var guideState = ref.watch(guideStateProvider);
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
                    right: isVisible
                        ? 0
                        : -(MediaQuery.of(context).size.width * 0.25),
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
                              target: NLatLng(
                                  position.latitude, position.longitude),
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
          if (guideState.isMetroGuide && guideState.metroSegment != null)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: MetroGuideView(
                  metroSegment: guideState.metroSegment!,
                  selectedTrainNo: guideState.selectedTrainNo ?? '',
                ),
              ),
            ),
        ],
      ),
    );
  }

  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _debounceTimer?.cancel();
    _trackingTimer?.cancel();
    _positionStreamSubscription?.cancel();
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
