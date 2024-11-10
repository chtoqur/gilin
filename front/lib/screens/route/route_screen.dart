import 'package:flutter/material.dart';
import 'package:gilin/widgets/route/main/route_selector_widget.dart';
import 'package:gilin/widgets/route/main/saved_locations_widget.dart';
import 'package:gilin/widgets/route/main/transport_selector_widget.dart';
import 'package:gap/gap.dart';

import '../../widgets/route/main/cupertino_time_picker.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  bool isPlaceTab = true;
  @override
  Widget build(BuildContext context) {
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
                  const Gap(15),
                  CupertinoTimePicker(
                    onDateTimeChanged: (DateTime time) {
                      // print("Selected time: ${time.hour}:${time.minute}");
                    },
                    initTimeStr: '', // 초기 시간 문자열
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
                  const Gap(30),
                  const Text(
                    '자주 가는 곳으로 빠른 길찾기',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF8F5F0)
                    ),
                  ),
                  const Gap(15),
                  const SavedLocationsWidget(),
                  const Gap(30),
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
              // 탭 했을 때의 동작
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
}
