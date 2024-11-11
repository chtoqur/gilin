import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../models/route/custom_route.dart';

class RouteSamples {
  // 테스트용 경로 데이터
  static final CustomRoute seoulCityHallToGyeongbokgung = CustomRoute(
    coordinates: [
      // 서울시청 출발
      const NLatLng(37.566295, 126.977945),
      // 시청역 방향
      const NLatLng(37.566382, 126.976999),
      const NLatLng(37.566485, 126.976424),
      // 광화문역 방향으로
      const NLatLng(37.566845, 126.976441),
      const NLatLng(37.567439, 126.976473),
      const NLatLng(37.568486, 126.976494),
      const NLatLng(37.569523, 126.976537),
      // 세종대로
      const NLatLng(37.570391, 126.976591),
      const NLatLng(37.571224, 126.976623),
      const NLatLng(37.572058, 126.976666),
      // 광화문 광장
      const NLatLng(37.572856, 126.976719),
      const NLatLng(37.573756, 126.976762),
      const NLatLng(37.574606, 126.976816),
      // 경복궁 방향으로
      const NLatLng(37.575431, 126.976869),
      const NLatLng(37.576192, 126.976912),
      // 경복궁 도착
      const NLatLng(37.577389, 126.976988),
    ],
    totalDistance: 1500,  // 미터
    estimatedTime: 1200,  // 20분
    routeType: 'walking',
  );

/* JSON 형식:
{
  "coordinates": [
    [37.566295, 126.977945],
    [37.566382, 126.976999],
    [37.566485, 126.976424],
    [37.566845, 126.976441],
    [37.567439, 126.976473],
    [37.568486, 126.976494],
    [37.569523, 126.976537],
    [37.570391, 126.976591],
    [37.571224, 126.976623],
    [37.572058, 126.976666],
    [37.572856, 126.976719],
    [37.573756, 126.976762],
    [37.574606, 126.976816],
    [37.575431, 126.976869],
    [37.576192, 126.976912],
    [37.577389, 126.976988]
  ],
  "total_distance": 1500,
  "estimated_time": 1200,
  "route_type": "walking"
}
*/
}