import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/search/local_search_result.dart';
import '../../widgets/search/search_bottom_sheet.dart';
import 'search_result_map.dart';

class SearchResultsMap extends ConsumerStatefulWidget {
  final List<LocalSearchResult> searchResults;

  const SearchResultsMap({
    Key? key,
    required this.searchResults,
  }) : super(key: key);

  @override
  ConsumerState<SearchResultsMap> createState() => _SearchResultsMapState();
}

class _SearchResultsMapState extends ConsumerState<SearchResultsMap> {
  NaverMapController? mapController;
  final Map<String, NMarker> markers = {};
  final Map<String, NInfoWindow> infoWindows = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeMarkersAndInfoWindows(
      NaverMapController controller) async {
    for (var result in widget.searchResults) {
      try {
        var lat = result.y;
        var lng = result.x;

        if (lat == 0 || lng == 0) continue;

        var position = NLatLng(lat, lng);
        var marker = NMarker(
          id: 'marker_${result.title}',
          position: position,
        );

        await controller.addOverlay(marker);
        markers[result.title] = marker;

        var infoWindow = NInfoWindow.onMarker(
          id: 'info_${result.title}',
          text: result.title,
        );

        await marker.openInfoWindow(infoWindow);
        infoWindows[result.title] = infoWindow;
      } catch (e) {
        print('Error adding marker for ${result.title}: $e');
      }
    }

    // 모든 마커가 보이도록 카메라 이동
    if (widget.searchResults.isNotEmpty) {
      var bounds = NLatLngBounds(
        southWest: NLatLng(
          widget.searchResults.map((r) => r.y).reduce((a, b) => a < b ? a : b),
          widget.searchResults.map((r) => r.x).reduce((a, b) => a < b ? a : b),
        ),
        northEast: NLatLng(
          widget.searchResults.map((r) => r.y).reduce((a, b) => a > b ? a : b),
          widget.searchResults.map((r) => r.x).reduce((a, b) => a > b ? a : b),
        ),
      );

      await controller.updateCamera(
        NCameraUpdate.fitBounds(
          bounds,
          padding: const EdgeInsets.all(50), // EdgeInsets 타입으로 수정
        ),
      );
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
                initializeMarkersAndInfoWindows(controller);
              },
            ),
            // 상단 앱바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      '검색 결과',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 검색 결과 하단 시트
            SearchBottomSheet(
              searchResults: widget.searchResults,
              onResultTap: (result) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultMap(
                      searchResult: result,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (mapController != null) {
      for (var marker in markers.values) {
        try {
          mapController?.deleteOverlay(
            NOverlayInfo(
              type: NOverlayType.marker,
              id: marker.info.id,
            ),
          );
        } catch (e) {
          print('Error removing marker: $e');
        }
      }
    }
    super.dispose();
  }
}
