import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gilin/widgets/route/myplace_screen.dart';
import 'package:gilin/widgets/route/myroute_screen.dart';
import 'package:gilin/widgets/route/search_bar.dart';
import 'package:gilin/screens/search/search_screen.dart';
import 'package:gilin/widgets/route//route_bottom_sheet.dart';
import 'package:gilin/widgets/route/bookmark_container.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

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
        const CustomSearchBar(),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '사용자',  // 나중에 서버에서 받아올 사용자 이름
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '님, 어디가시나요?',
                            style: TextStyle(
                              fontSize: 20,
                            )
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Row의 전체 너비를 가져와 5등분한 크기를 각 컨테이너의 너비로 설정
                        double containerWidth = (constraints.maxWidth / 5) - 20;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BookmarkContainer(title: '집', iconData: 'home', width: containerWidth),
                            const SizedBox(width: 20), // 요소 간 간격
                            BookmarkContainer(title: '회사/학교', iconData: 'building', width: containerWidth),
                            const SizedBox(width: 20),
                            BookmarkContainer(title: '추가하기', iconData: 'add', width: containerWidth),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const Gap(20),
                // 탭 버튼들
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF8EAAB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isPlaceTab = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isPlaceTab ? const Color(0xFF463C33) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/pin.svg',
                                  width: 17,
                                  height: 17,
                                  colorFilter: ColorFilter.mode(
                                    isPlaceTab ? Colors.white : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  '장소',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isPlaceTab ? Colors.white : Colors.black
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isPlaceTab = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isPlaceTab ? const Color(0xff463C33) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/road.svg',
                                  width: 17,
                                  height: 17,
                                  colorFilter: ColorFilter.mode(
                                    !isPlaceTab ? Colors.white : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  '경로',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: !isPlaceTab ? Colors.white : Colors.black,
                                  ),
                                )
                              ],
                            ),
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
