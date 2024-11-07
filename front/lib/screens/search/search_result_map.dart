import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/search/local_search_result.dart';
import '../../widgets/search/search_result_map_info.dart';

class SearchResultMap extends ConsumerStatefulWidget {
  final LocalSearchResult searchResult;

  const SearchResultMap({
    Key? key,
    required this.searchResult,
  }) : super(key: key);

  @override
  ConsumerState<SearchResultMap> createState() => _SearchResultMapState();
}

class _SearchResultMapState extends ConsumerState<SearchResultMap> {
  NaverMapController? mapController;
  NMarker? currentMarker;
  NInfoWindow? infoWindow;

  Future<void> initializeMarkerAndInfoWindow(
      NaverMapController controller) async {
    try {
      var lat = widget.searchResult.mapy / 10000000;
      var lng = widget.searchResult.mapx / 10000000;

      print('Converting coordinates to lat/lng: $lat, $lng');

      if (lat.isNaN || lng.isNaN) {
        throw Exception('Invalid coordinates: lat=$lat, lng=$lng');
      }

      final position = NLatLng(lat, lng);

      currentMarker = NMarker(
        id: 'marker_${widget.searchResult.title}',
        position: position,
      );

      print('Adding marker to map at position: $position');
      await controller.addOverlay(currentMarker!);

      infoWindow = NInfoWindow.onMarker(
        id: 'info_${widget.searchResult.title}',
        text: widget.searchResult.title,
      );

      await currentMarker!.openInfoWindow(infoWindow!);

      await controller.updateCamera(
        NCameraUpdate.withParams(
          target: position,
          zoom: 15,
        ),
      );
    } catch (e, stackTrace) {
      print('Error initializing marker: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('위치를 지도에 표시하는 중 오류가 발생했습니다: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            NaverMap(
              options: const NaverMapViewOptions(
                indoorEnable: true,
                locationButtonEnable: false,
              ),
              onMapReady: (controller) {
                mapController = controller;
                initializeMarkerAndInfoWindow(controller);
              },
            ),

            // 상단 앱바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  // 뒤로가기 버튼
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  // 장소 이름
                  Expanded(
                    child: Text(
                      widget.searchResult.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // 하단 정보 컨테이너
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SearchResultMapInfo(
                searchResult: widget.searchResult,
                onStartPressed: () {
                  // TODO: 출발지 설정 로직 구현
                },
                onEndPressed: () {
                  // TODO: 도착지 설정 로직 구현
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (mapController != null && currentMarker != null) {
      try {
        // currentMarker?.closeInfoWindow();
        mapController?.deleteOverlay(
          NOverlayInfo(
            type: NOverlayType.marker,
            id: currentMarker!.info.id,
          ),
        );
      } catch (e) {
        print('Error during cleanup: $e');
      }
    }
    super.dispose();
  }
}
