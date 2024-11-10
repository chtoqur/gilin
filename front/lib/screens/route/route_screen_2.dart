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
  bool isPlaceTab = true;
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
        CustomSearchBar(
          readOnly: true,
          isRouteScreen: true,
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SearchScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
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
                            text: '사용자',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                              text: '님, 어디가시나요?',
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        ],
                      ),
                    ),
                    const Gap(15),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double containerWidth = (constraints.maxWidth / 2) - 20;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BookmarkContainer(
                                title: '집',
                                iconData: 'home',
                                width: containerWidth),
                            const Gap(20),
                            BookmarkContainer(
                                title: '회사/학교',
                                iconData: 'building',
                                width: containerWidth),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const Gap(20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8EAAB),
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
                              color: isPlaceTab
                                  ? const Color(0xFF463C33)
                                  : Colors.transparent,
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
                                      color: isPlaceTab
                                          ? Colors.white
                                          : Colors.black),
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
                              color: !isPlaceTab
                                  ? const Color(0xff463C33)
                                  : Colors.transparent,
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
                                    color: !isPlaceTab
                                        ? Colors.white
                                        : Colors.black,
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
                Expanded(
                  child: isPlaceTab
                      ? const MyplaceScreen()
                      : const MyrouteScreen(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
