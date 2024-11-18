import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/models/route/transit_route.dart';
import 'package:gilin/state/navigation/navigation_provider.dart';
import 'package:go_router/go_router.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Schedule Home Screen'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                ref.read(bottomNavProvider.notifier).navigateToPage(
                    context,
                    0, // route 화면의 인덱스
                    '/route'),
            child: const Text('Go to Route'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref
                .read(bottomNavProvider.notifier)
                .navigateToPage(context, 3, '/test'),
            child: const Text('Go to test Screen'),
          ),
          ElevatedButton(
            onPressed: () => ref
                .read(bottomNavProvider.notifier)
                .navigateToPage(context, 0, '/my_route'),
            child: const Text('Go to My Route Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).updateIndex(3);
              context.push('/signup_step1');
            },
            child: const Text('Go to SignUp Page'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).updateIndex(3);
              context.push('/success');
            },
            child: const Text('Go to Success Page'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(bottomNavProvider.notifier).updateIndex(3);
              context.push('/failure');
            },
            child: const Text('Go to Failure Page'),
          ),
          ElevatedButton(
            onPressed: () {
              // // ref.read(bottomNavProvider.notifier).updateIndex(3);
              // // ref.read(arrivalTimeProvider.notifier).setArrivalTime(
              // //     DateTime.now().add(const Duration(minutes: 10))
              // // );
              // print("arrival time");
              // print(ref.read(arrivalTimeProvider).arrivalTime);
              context.push('/test');
            },
            child: const Text('Go to Arrival Time Test Page'),
          ),
          ElevatedButton(
            onPressed: () => ref
                .read(bottomNavProvider.notifier)
                .navigateToPage(context, 1, '/login'),
            child: const Text('Go to login Page'),
          ),
          ElevatedButton(
            onPressed: () {
              final routeData = TransitRoute(
                info: RouteInfo(
                  trafficDistance: 10075,
                  totalWalk: 654,
                  totalTime: 32,
                  payment: 1550,
                  busTransitCount: 1,
                  subwayTransitCount: 1,
                  firstStartStation: "광나루역.극동아파트",
                  lastEndStation: "역삼",
                  totalStationCount: 10,
                  busStationCount: 3,
                  subwayStationCount: 7,
                  totalDistance: 10729,
                  totalIntervalTime: 13,
                ),
                subPath: [
                  TransitSegment(
                    travelType: TransitType.METRO,
                    startName: "광나루역",
                    startX: 127.103257,
                    startY: 37.544185,
                    endName: "강변역",
                    endX: 127.093713,
                    endY: 37.536111,
                    lane: [Lane(
                      name: "5호선",
                      type: 1,
                      subwayCode: 5, busNo: '146', busID: 123, busLocalBlID: '',
                    )], pathGraph: [], distance: 10,
                    sectionTime: 10, stationCount: 10, intervalTime: 10, way: '',
                    wayCode: 10, startID: 13, startLocalStationID: '', startArsID: '',
                    endID: 12, endLocalStationID: '', endArsID: '',
                    passStopList: PassStopList(stations: []),
                  ),
                  TransitSegment(
                    travelType: TransitType.WALK,
                    startName: "강변역",
                    startX: 127.093713,
                    startY: 37.536111,
                    endName: "강변역 버스정류장",
                    endX: 127.093000,
                    endY: 37.535000,
                    distance: 200,
                    lane: [Lane(
                      name: "5호선",
                      type: 1,
                      subwayCode: 5, busNo: '146', busID: 123, busLocalBlID: '',
                    )], pathGraph: [],
                    sectionTime: 10, stationCount: 10, intervalTime: 10, way: '',
                    wayCode: 10, startID: 13, startLocalStationID: '', startArsID: '',
                    endID: 12, endLocalStationID: '', endArsID: '',
                    passStopList: PassStopList(stations: []),
                  ),
                  TransitSegment(
                    travelType: TransitType.BUS,
                    startName: "강변역 버스정류장",
                    startX: 127.093000,
                    startY: 37.535000,
                    endName: "역삼역",
                    endX: 127.036413,
                    endY: 37.500489,
                    distance: 200,
                    lane: [Lane(
                      name: "5호선",
                      type: 1,
                      subwayCode: 5, busNo: '146', busID: 123, busLocalBlID: '',
                    )], pathGraph: [],
                    sectionTime: 10, stationCount: 10, intervalTime: 10, way: '',
                    wayCode: 10, startID: 13, startLocalStationID: '', startArsID: '',
                    endID: 12, endLocalStationID: '', endArsID: '',
                    passStopList: PassStopList(stations: []),
                  ),
                ],
              );

              ref.read(bottomNavProvider.notifier)
                  .navigateToPage(context, 1, '/test_location', extra: routeData,);
            },
            child: const Text('Go to test location page'),
          ),
        ],
      ),
    );
  }
}
