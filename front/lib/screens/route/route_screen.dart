import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gilin/screens/route/myplace_screen.dart';
import 'package:gilin/screens/route/myroute_screen.dart';
import 'package:gilin/screens/route/widgets/search_bar.dart';
import 'package:gilin/screens/search/search_screen.dart';
import 'dart:async';
import 'widgets/route_bottom_sheet.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  bool isPlaceTab = true;  // true: 장소 탭, false: 경로 탭
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: false,
          ),
          onMapReady: (controller) async {
            mapControllerCompleter.complete(controller);
          },
        ),
        const CustomSearchBar(),  // SearchBar -> CustomSearchBar로 변경
        // 또는
        // RouteScreen에서
        // RouteScreen에서
        CustomSearchBar(
          readOnly: true,
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        RouteBottomSheet(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '사용자',  // 나중에 서버에서 받아올 사용자 이름
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '님, 어디가시나요?',
                            ),
                          ],
                        ),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          bookmarkContainer(title: '집', iconData: 'home'),
                          bookmarkContainer(title: '회사/학교', iconData: 'home'),
                          bookmarkContainer(title: '추가하기', iconData: 'home'),
                        ],
                      )
                    ],
                  ),
                ),
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

Widget bookmarkContainer({String title = '집', String iconData = 'home'}) {
  return Container(
    height: 50,
    child: Center(
      child: Text(title),
    ),
  );
}