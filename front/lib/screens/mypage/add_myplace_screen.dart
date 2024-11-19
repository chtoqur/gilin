import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gilin/state/user/location_state.dart';
import 'package:go_router/go_router.dart';

import '../../state/route/route_state.dart';

final selectedTabProvider = StateProvider<String>((ref) => 'home');
final placeNameProvider = StateProvider<String>((ref) => '');
final selectedTimeProvider = StateProvider<DateTime>((ref) =>
    DateTime.now().toLocal().add(const Duration(hours: 9))); // 한국 시간 기준 초기화

class AddMyPlaceScreen extends ConsumerStatefulWidget {
  const AddMyPlaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddMyPlaceScreen> createState() => _AddMyPlaceScreenState();
}

class _AddMyPlaceScreenState extends ConsumerState<AddMyPlaceScreen> {
  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: ref.read(selectedTimeProvider),
            mode: CupertinoDatePickerMode.time,
            use24hFormat: false,
            onDateTimeChanged: (DateTime newTime) {
              ref.read(selectedTimeProvider.notifier).state = newTime;
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectedTab = ref.watch(selectedTabProvider);
    var placeName = ref.watch(placeNameProvider);
    var hasInput = selectedTab == 'other' ? placeName.isNotEmpty : true;
    var locationState = ref.watch(locationProvider);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xffF8F5F0),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '자주가는 장소를\n등록해보세요',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff463C33),
                    ),
                  ),
                  const Gap(8),
                  const Text(
                    '자주가는 주소를 등록하면 빠른 길찾기가 가능해요',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff463C33),
                    ),
                  ),
                  const Gap(30),
                  // 탭 버튼들
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFF463C33), width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            _buildTabButton(
                                ref, 'home', '집', 'home', selectedTab),
                            _buildTabButton(
                                ref, 'company', '회사', 'company', selectedTab),
                            _buildTabButton(
                                ref, 'school', '학교', 'school', selectedTab),
                            _buildTabButton(
                                ref, 'other', '기타', 'place', selectedTab),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  if (selectedTab == 'other')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15), // vertical 패딩 제거
                          color: const Color(0xFFECECEC),
                          child: Center(
                            // Center 위젯 추가
                            child: TextField(
                              onChanged: (value) {
                                ref.read(placeNameProvider.notifier).state =
                                    value;
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '장소 이름을 입력해주세요',
                                hintStyle: TextStyle(
                                  color: Color(0xFF777777),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                color: Color(0xFF3A3A3A),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Gap(15),
                  // 주소 입력 필드
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    color: const Color(0xFFECECEC),
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(routeProvider.notifier)
                            .setCurrentScreen('add_myplace');
                        context.push('/search');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locationState.point.title.isNotEmpty
                                  ? locationState.point.address
                                  : "주소를 등록해주세요",
                              style: const TextStyle(
                                color: Color(0xFF777777),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Icon(
                              Icons.add_circle_outline,
                              size: 20,
                              color: Color(0xFF777777),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(15),
                  // 시간 선택 필드
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    color: const Color(0xFFECECEC),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.access_time, size: 20),
                            Gap(5),
                            Text(
                              '도착 시간',
                              style: TextStyle(
                                color: Color(0xFF3A3A3A),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _showTimePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Consumer(
                              builder: (context, ref, child) {
                                var selectedTime =
                                    ref.watch(selectedTimeProvider);
                                return Text(
                                  '${selectedTime.hour < 12 ? "오전" : "오후"} '
                                  '${(selectedTime.hour > 12 ? selectedTime.hour - 12 : selectedTime.hour).toString().padLeft(2, '0')}:'
                                  '${selectedTime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 하단 저장 버튼
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: hasInput
                      ? const Color(0xFF669358)
                      : const Color(0xFFD9D9D9),
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
                        '저장하기',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:
                              hasInput ? Colors.white : const Color(0xFF757575),
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

  Widget _buildTabButton(WidgetRef ref, String value, String label, String icon,
      String selectedTab) {
    var isSelected = value == selectedTab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedTabProvider.notifier).state = value;
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE5DCCF) : null,
            border: value != 'other'
                ? const Border(
                    right: BorderSide(
                      color: Color(0xFF463C33),
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/streamline/$icon.svg',
                width: 18,
                height: 18,
              ),
              const Gap(5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF463C33),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
