import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/widgets/route/main/route_selector_widget.dart';
import 'package:gilin/widgets/route/main/transport_selector_widget.dart';
import 'package:gap/gap.dart';
import 'package:gilin/widgets/shared/popup/taxi_info_popup.dart';

import '../../state/route/route_state.dart';

// 팝업 표시 상태 관리 provider
final taxiPopupVisibilityProvider = StateProvider<bool>((ref) => false);

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  bool isPlaceTab = true;

  @override
  Widget build(BuildContext context) {
    ref.watch(routeProvider);
    var isPopupVisible = ref.watch(taxiPopupVisibilityProvider);

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
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CupertinoDatePicker(
                      initialDateTime: ref.read(routeProvider).arrivalTime ?? DateTime.now(),
                      onDateTimeChanged: (DateTime time) {
                        ref.read(routeProvider.notifier).setArrivalTime(time);
                      },
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: false,
                      minuteInterval: 5,
                    ),
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

        if (isPopupVisible)
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            left: 20,
            right: 20,
            child: TaxiInfoPopup(
              location: ref.read(routeProvider).startPoint.title,
              estimatedTime: _formatTime(ref.read(routeProvider).arrivalTime),
              estimatedCost: 5700, // 예시 금액, 데이터로 반환
              onClose: () {
                ref.read(taxiPopupVisibilityProvider.notifier).state = false;
              },
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
              // 팝업 표시
              ref.read(taxiPopupVisibilityProvider.notifier).state = true;

              var routeState = ref.read(routeProvider);
              print('=== 경로 정보 ===');
              print('출발지: ${routeState.startPoint.title} (${routeState.startPoint.x}, ${routeState.startPoint.y})');
              print('도착지: ${routeState.endPoint.title} (${routeState.endPoint.x}, ${routeState.endPoint.y})');
              print('도착 시간: ${routeState.arrivalTime?.hour}시 ${routeState.arrivalTime?.minute}분');
              print('선택된 이동수단: ${routeState.selectedTransports.join(", ")}');
              print('===============');
            },
            child: const SizedBox(
              height: 35,
              child: Center(
                child: Text(
                  '출발하기',
                  style: TextStyle(
                    color: Color(0xFF463C33),
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

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    String period = time.hour < 12 ? '오전' : '오후';
    int hour = time.hour <= 12 ? time.hour : time.hour - 12;
    return '$period $hour시 ${time.minute}분';
  }
}