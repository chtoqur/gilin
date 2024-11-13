// // lib/utils/sample_data/route_samples.dart
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import '../../models/route/transit_route.dart';
//
// class RouteSamples {
//   static final TransitRoute seoulCityHallToGyeongbokgung = TransitRoute(
//     segments: [
//       // 시청에서 버스정류장까지 도보
//       TransitSegment(
//         type: TransitType.walking,
//         coordinates: [
//           const NLatLng(37.566295, 126.977945),  // 시청
//           const NLatLng(37.566382, 126.976999),
//           const NLatLng(37.566485, 126.976424),  // 버스정류장
//         ],
//         startName: '시청',
//         endName: '시청 버스정류장',
//         duration: 5,
//         distance: 200,
//       ),
//       // 버스로 이동
//       TransitSegment(
//         type: TransitType.bus,
//         coordinates: [
//           const NLatLng(37.566485, 126.976424),  // 시청 버스정류장
//           const NLatLng(37.566845, 126.976441),
//           const NLatLng(37.567439, 126.976473),
//           const NLatLng(37.568486, 126.976494),
//           const NLatLng(37.569523, 126.976537),
//           const NLatLng(37.570391, 126.976591),  // 광화문 버스정류장
//         ],
//         startName: '시청 버스정류장',
//         endName: '광화문 버스정류장',
//         duration: 10,
//         distance: 500,
//       ),
//       // 광화문역에서 지하철
//       TransitSegment(
//         type: TransitType.subway,
//         coordinates: [
//           const NLatLng(37.570391, 126.976591),  // 광화문역
//           const NLatLng(37.571224, 126.976623),
//           const NLatLng(37.572058, 126.976666),
//           const NLatLng(37.572856, 126.976719),  // 경복궁역
//         ],
//         startName: '광화문역',
//         endName: '경복궁역',
//         duration: 8,
//         distance: 400,
//       ),
//       // 경복궁역에서 경복궁까지 도보
//       TransitSegment(
//         type: TransitType.walking,
//         coordinates: [
//           const NLatLng(37.572856, 126.976719),  // 경복궁역
//           const NLatLng(37.573756, 126.976762),
//           const NLatLng(37.574606, 126.976816),
//           const NLatLng(37.575431, 126.976869),
//           const NLatLng(37.576192, 126.976912),
//           const NLatLng(37.577389, 126.976988),  // 경복궁
//         ],
//         startName: '경복궁역',
//         endName: '경복궁',
//         duration: 12,
//         distance: 400,
//       ),
//     ],
//     totalDuration: 35,  // 총 35분
//     totalDistance: 1500.0,  // 총 1.5km
//   );
//
// /* JSON 형식:
//   {
//     "segments": [
//       {
//         "type": "walking",
//         "coordinates": [
//           [37.566295, 126.977945],
//           [37.566382, 126.976999],
//           [37.566485, 126.976424]
//         ],
//         "start_name": "시청",
//         "end_name": "시청 버스정류장",
//         "duration": 5,
//         "distance": 200.0
//       },
//       {
//         "type": "bus",
//         "coordinates": [
//           [37.566485, 126.976424],
//           [37.566845, 126.976441],
//           [37.567439, 126.976473],
//           [37.568486, 126.976494],
//           [37.569523, 126.976537],
//           [37.570391, 126.976591]
//         ],
//         "start_name": "시청 버스정류장",
//         "end_name": "광화문 버스정류장",
//         "duration": 10,
//         "distance": 500.0
//       },
//       {
//         "type": "subway",
//         "coordinates": [
//           [37.570391, 126.976591],
//           [37.571224, 126.976623],
//           [37.572058, 126.976666],
//           [37.572856, 126.976719]
//         ],
//         "start_name": "광화문역",
//         "end_name": "경복궁역",
//         "duration": 8,
//         "distance": 400.0
//       },
//       {
//         "type": "walking",
//         "coordinates": [
//           [37.572856, 126.976719],
//           [37.573756, 126.976762],
//           [37.574606, 126.976816],
//           [37.575431, 126.976869],
//           [37.576192, 126.976912],
//           [37.577389, 126.976988]
//         ],
//         "start_name": "경복궁역",
//         "end_name": "경복궁",
//         "duration": 12,
//         "distance": 400.0
//       }
//     ],
//     "total_duration": 35,
//     "total_distance": 1500.0
//   }
//   */
//
// // 필요한 경우 추가 샘플 경로들...
// }