import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/widgets/route/main/route_selector_widget.dart';
import 'package:gilin/widgets/route/main/transport_selector_widget.dart';
import 'package:gap/gap.dart';

import '../../state/route/route_state.dart';
import '../../widgets/route/main/cupertino_time_picker.dart';

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

  final routeProvider = StateNotifierProvider<RouteNotifier, RouteState>((ref) {
    return RouteNotifier();
  });

class _RouteScreenState extends ConsumerState<RouteScreen> {
  bool isPlaceTab = true;

  @override
  Widget build(BuildContext context) {
    var routeState = ref.watch(routeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF8C9F5F),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '어디로, 몇 시까지 가시나요?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF8F5F0)
                    ),
                  ),
                  const Gap(15),
                  const RouteSelectorWidget(),
                  const Gap(30),
                  const Text(
                    '몇 시까지 가시나요?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF8F5F0)
                    ),
                  ),
                  const Gap(15),
                  CupertinoTimePicker(
                    // onDateTimeChanged: (DateTime time) {
                    //   ref.read(routeProvider.notifier).setArrivalTime(time);
                    // },
                    // initTimeStr: routeState.arrivalTime?.toString() ?? '',
                    onDateTimeChanged: (DateTime time) {
                      print('선택된 시간: $time');
                      ref.read(routeProvider.notifier).setArrivalTime(time);
                      // 시간 설정 후 상태 확인
                      final updatedTime = ref.read(routeProvider).arrivalTime;
                      print('업데이트된 시간: $updatedTime');
                    },
                    initTimeStr: ref.watch(routeProvider).arrivalTime?.toString() ?? '',
                  ),


                  const Gap(30),
                  const Text(
                    '이동수단을 선택해주세요.',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF8F5F0)
                    ),
                  ),
                  const Gap(15),
                  const TransportSelectorWidget(),
                  const Gap(15),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8EAAB),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              var currentState = ref.read(routeProvider);
              print('=== 현재 상태값 ===');
              print('출발지: ${currentState.startPoint.title} (${currentState.startPoint.x}, ${currentState.startPoint.y})');
              print('도착지: ${currentState.endPoint.title} (${currentState.endPoint.x}, ${currentState.endPoint.y})');
              print('도착 시간: ${currentState.arrivalTime}');
              print('선택된 이동수단: ${currentState.selectedTransportModes}');

              // isReadyToStart 조건 각각 확인
              print('\n=== 조건 체크 ===');
              print('출발지 입력됨: ${currentState.startPoint.title.isNotEmpty}');
              print('도착지 입력됨: ${currentState.endPoint.title.isNotEmpty}');
              print('도착시간 입력됨: ${currentState.arrivalTime != null}');
              print('이동수단 선택됨: ${currentState.selectedTransportModes.isNotEmpty}');

              if (ref.read(routeProvider.notifier).isReadyToStart()) {
                print('\n모든 조건 만족! 다음 단계로 진행합니다.');
                // 여기에 다음 단계로 진행하는 로직 구현
              } else {
                print('\n조건 불만족. 사용자에게 알림');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('모든 정보를 입력해주세요.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: ref.read(routeProvider.notifier).isReadyToStart()
                    ? const Color(0xFF8C9F5F)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '출발하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}