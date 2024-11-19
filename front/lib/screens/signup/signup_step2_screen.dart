import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../state/user/locations_state.dart';
import '../../widgets/mypage/place_input_widget.dart';

class SignupStep2Screen extends ConsumerWidget {
  const SignupStep2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locationState = ref.watch(locationsProvider);
    var hasAddress = locationState.homePoint.address.isNotEmpty ||
        locationState.companyPoint.address.isNotEmpty ||
        locationState.schoolPoint.address.isNotEmpty;

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xffF8F5F0),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 45,
                    left: 35,
                    right: 35,
                    bottom: 120,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '자주가는 장소를\n등록해보세요',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff463C33)),
                        ),
                        const Gap(5),
                        const Text(
                          '집과 학교/직장 주소를 등록하면 빠른 길찾기가 가능해요',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff463C33),
                          ),
                        ),
                        const Gap(40),
                        PlaceInputWidget(
                          identifier: 'home',
                          placeName: 'home',
                          icon: Icons.location_on,
                          onPlaceNameChanged: (String newName) {
                            print('New place name: $newName');
                          },
                          onTimeChanged: (DateTime newTime) {
                            print('New time selected: $newTime');
                          },
                        ),
                        const Gap(30),
                        PlaceInputWidget(
                          identifier: 'company',
                          placeName: 'company',
                          icon: Icons.location_on,
                          onPlaceNameChanged: (String newName) {
                            print('New place name: $newName');
                          },
                          onTimeChanged: (DateTime newTime) {
                            print('New time selected: $newTime');
                          },
                        ),
                        const Gap(30),
                        PlaceInputWidget(
                          identifier: 'school',
                          placeName: 'school',
                          icon: Icons.location_on,
                          onPlaceNameChanged: (String newName) {
                            print('New place name: $newName');
                          },
                          onTimeChanged: (DateTime newTime) {
                            print('New time selected: $newTime');
                          },
                        )
                      ])),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (hasAddress) {
                    // 저장 로직
                  } else {
                    // 나중에 하기 로직
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF669358),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Center(
                        child: Text(
                          hasAddress ? '저장하기' : '나중에 할래요',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
