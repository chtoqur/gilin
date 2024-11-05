// route_screen.dart
import 'package:flutter/material.dart';
import 'package:gilin/screens/route/myplace_screen.dart';
import 'package:gilin/screens/route/myroute_screen.dart';
import 'myplace_screen.dart';
import 'myroute_screen.dart';
import 'widgets/route_bottom_sheet.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  bool isPlaceTab = true;  // true: 장소 탭, false: 경로 탭

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 지도 영역 (나중에 실제 지도로 교체)
        const Center(
          child: Text('Map Area'),
        ),
        // 바텀 시트
        RouteBottomSheet(
          child: SizedBox( // Column을 SizedBox로 감싸기
            height: MediaQuery.of(context).size.height * 0.7, // 적절한 높이 설정
            child: Column(
              children: [
                // 탭 버튼들
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isPlaceTab = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isPlaceTab ? Color(0xFF463C33) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(child: Text('장소')),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isPlaceTab = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isPlaceTab ? Color(0xFF463C33) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Center(child: Text('경로')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 탭 내용
                Expanded(
                  child: isPlaceTab ? const MyplaceScreen() : const MyrouteScreen(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}