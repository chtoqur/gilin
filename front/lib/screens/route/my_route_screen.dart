import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gilin/models/route/destination.dart';
import 'package:gilin/widgets/route/main/destination_card.dart';
import 'package:go_router/go_router.dart';

import '../../state/route/route_state.dart';
import '../../state/route/service_providers.dart';
import '../../widgets/route/main/transport_selector_widget.dart';
import '../guide/guide_preview_screen.dart';
import 'package:geolocator/geolocator.dart';

class MyRouteScreen extends ConsumerStatefulWidget {
const MyRouteScreen({super.key});

@override
ConsumerState<MyRouteScreen> createState() => _MyRouteScreenState();
}

class _MyRouteScreenState extends ConsumerState<MyRouteScreen> {
  int? selectedDestinationIndex;
  bool isLoading = false;

  final List<Destination> destinations = [
    const Destination(
      iconPath: 'assets/images/streamline/home.svg',
      name: '집',
      address: '서울 종로구 계동길 37',
      arrivalTime: 'PM 6:00',
      x: 126.98481245064092,
      y: 37.581768153833444,
    ),
    const Destination(
      iconPath: 'assets/images/streamline/company.svg',
      name: '회사',
      address: '서울 서초구 서초대로74길 11 삼성전자빌딩',
      arrivalTime: 'AM 8:00',
      x: 126.98481245064092,
      y: 37.581768153833444,
    ),
    const Destination(
      iconPath: 'assets/images/streamline/school.svg',
      name: '학교',
      address: '서울 관악구 관악로 1',
      arrivalTime: 'AM 9:00',
      x: 126.98481245064092,
      y: 37.581768153833444,
    ),
    const Destination(
      iconPath: 'assets/images/streamline/place.svg',
      name: '카페',
      address: '서울 서초구 동광로 11 빈센트빌딩 1층',
      arrivalTime: 'PM 2:00',
      x: 126.98481245064092,
      y: 37.581768153833444,
    ),
    const Destination(
      iconPath: 'assets/images/streamline/place.svg',
      name: '식당',
      address: '서울 송파구 올림픽로',
      arrivalTime: 'PM 7:00',
      x: 126.98481245064092,
      y: 37.581768153833444,
    ),
  ];

  Future<void> _handleStartNavigation() async {
    if (selectedDestinationIndex == null) {
      await context.push('/route');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final routeState = ref.read(routeProvider);
      final routeService = ref.read(routeServiceProvider);

      // Parse arrival time from the selected destination
      final selectedDestination = destinations[selectedDestinationIndex!];
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      final currentX = position.longitude;
      final currentY = position.latitude;

      final now = DateTime.now();
      final arrivalTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedDestination.arrivalTime.startsWith('PM') ?
        (int.parse(selectedDestination.arrivalTime.split(':')[0].substring(3)) + 12) :
        int.parse(selectedDestination.arrivalTime.split(':')[0].substring(3)),
        int.parse(selectedDestination.arrivalTime.split(':')[1].substring(0, 2)),
      );

      final transitRoute = await routeService.getRoute(
        sx: routeState.startPoint.x,
        sy: routeState.startPoint.y,
        ex: selectedDestination.x,
        ey: selectedDestination.y,  // 선택된 목적지 y 좌표
        travelTypes: ['METRO', 'BUS', 'WALK', 'TAXI', 'BICYCLE'],
        arrivalTime: arrivalTime,
      );

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GuidePreviewScreen(
            routeData: transitRoute,
            routeState: routeState,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('경로를 불러오는데 실패했습니다: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  Widget _buildDestinationGrid() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF839559),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF8F5F0).withOpacity(0.2),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: [
          ...List.generate(
            destinations.length,
                (index) => DestinationCard(
              destination: destinations[index],
              isSelected: selectedDestinationIndex == index,
              onTap: () {
                setState(() {
                  selectedDestinationIndex =
                  selectedDestinationIndex == index ? null : index;
                });
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              // 추가하기 버튼 클릭 시 동작
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF8F5F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFF8F5F0).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffF8F5F0),
                      border: Border.all(color: const Color(0xff463C33), width: 1),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/streamline/add.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '추가하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff463C33),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8C9F5F),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    const Gap(40),
                    SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Image.asset(
                                'assets/images/gilin.webp',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 30, 20),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: RichText(
                                  textAlign: TextAlign.right,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '싸피',
                                        style: TextStyle(
                                          color: Color(0xFFF8EAAB),
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '님,\n',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '어디로 가시나요?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildDestinationGrid(),
                    ),
                    if (selectedDestinationIndex != null)
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),

                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이용가능한 이동수단',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Color(0xffF8F5F0),
                              ),
                            ),
                            SizedBox(height: 16),
                            TransportSelectorWidget(),
                          ],
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: selectedDestinationIndex == null
                  ? const Color(0xFFF8EAAB)
                  : const Color(0xFFFDA868),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(  // SizedBox로 감싸서 전체 너비 지정
                  width: double.infinity,
                  child: FilledButton(
                    // onPressed: () {
                    //   if (selectedDestinationIndex == null) { // 다른 도착지
                    //     context.push('/route');
                    //   } else {  // 출발하기
                    //
                    //   }
                    // },
                    onPressed: isLoading ? null : _handleStartNavigation,

                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF463C33),
                      ),
                    )
                        : Text(
                      selectedDestinationIndex != null ? '출발하기' : '다른 도착지',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF463C33),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _isLoading {
}