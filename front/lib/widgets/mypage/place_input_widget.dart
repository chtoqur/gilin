import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../state/route/route_state.dart';
import '../../state/user/locations_state.dart';

class PlaceInputWidget extends ConsumerStatefulWidget {
  final String placeName;
  final String? address;
  final IconData icon;
  final Function(String) onPlaceNameChanged;
  final Function(DateTime) onTimeChanged;
  final String identifier; // 'home', 'company', 'school'

  const PlaceInputWidget({
    Key? key,
    required this.placeName,
    this.address,
    required this.icon,
    required this.onPlaceNameChanged,
    required this.onTimeChanged,
    required this.identifier,
  }) : super(key: key);

  @override
  ConsumerState<PlaceInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends ConsumerState<PlaceInputWidget> {
  late TextEditingController _placeNameController;
  late DateTime _selectedTime;
  int _textLength = 0;

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController(
        text: widget.placeName == 'other' ? '' : widget.placeName);
    _selectedTime =
        DateTime.now().toLocal().add(const Duration(hours: 9)); // 한국 시간 기준 초기화
    _textLength = _placeNameController.text.characters.length;

    _placeNameController.addListener(() {
      setState(() {
        _textLength = _placeNameController.text.characters.length;
      });
    });
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    super.dispose();
  }

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
            initialDateTime: _selectedTime,
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                _selectedTime = newTime;
                widget.onTimeChanged(newTime);
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 35,
              height: 35,
              child: Consumer(builder: (context, ref, child) {
                var locationState = ref.watch(locationsProvider);

                String address = '';
                switch (widget.identifier) {
                  case 'home':
                    address = locationState.homePoint.address;
                    break;
                  case 'company':
                    address = locationState.companyPoint.address;
                    break;
                  case 'school':
                    address = locationState.schoolPoint.address;
                    break;
                }

                String iconPath = address.isNotEmpty
                    ? 'assets/images/icons/check.svg'
                    : switch (widget.identifier) {
                        'home' => 'assets/images/streamline/home.svg',
                        'company' => 'assets/images/streamline/company.svg',
                        'school' => 'assets/images/streamline/school.svg',
                        _ => 'assets/images/streamline/place.svg',
                      };

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: address.isNotEmpty
                        ? const Color(0xFF579F3E)
                        : Colors.transparent,
                    border: Border.all(
                      color: address.isNotEmpty
                          ? Colors.transparent
                          : const Color(0xFF000000),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 20,
                      height: 20,
                      // address가 있을 때는 아이콘 색상을 흰색으로 변경
                      colorFilter: address.isNotEmpty
                          ? const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn)
                          : null,
                    ),
                  ),
                );
              }),
            ),
            const Gap(14),
            if (widget.placeName == 'other') ...[
              Expanded(
                child: TextField(
                  controller: _placeNameController,
                  maxLength: 15,
                  style: const TextStyle(
                    color: Color(0xFF3A3A3A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: '장소명을 입력하세요',
                    hintStyle: TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (value) {
                    widget.onPlaceNameChanged(value);
                  },
                ),
              ),
              Text(
                '$_textLength/15',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ] else
              Expanded(
                child: Text(
                  switch (widget.placeName) {
                    'home' => '집',
                    'company' => '회사',
                    'school' => '학교',
                    _ => widget.placeName, // 기본값
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const Gap(12),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: const Color(0xFFECECEC),
          child: GestureDetector(
            onTap: () {
              ref.read(routeProvider.notifier).setCurrentScreen('signup_step2');
              ref
                  .read(locationsProvider.notifier)
                  .setSelectedWidget(widget.identifier);
              context.push('/search');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Consumer(
                builder: (context, ref, child) {
                  var locationState = ref.watch(locationsProvider);

                  String address = '';
                  switch (widget.identifier) {
                    case 'home':
                      address = locationState.homePoint.address;
                      break;
                    case 'company':
                      address = locationState.companyPoint.address;
                      break;
                    case 'school':
                      address = locationState.schoolPoint.address;
                      break;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max, // 추가
                    children: [
                      Text(
                        address.isNotEmpty ? address : '주소를 등록해주세요',
                        style: TextStyle(
                          color: address.isNotEmpty
                              ? Colors.black
                              : const Color(0xFF777777),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (address.isEmpty)
                        const Icon(
                          Icons.add_circle_outline,
                          size: 20,
                          color: Color(0xFF777777),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const Gap(12),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: const Color(0xFFECECEC),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽 아이템들을 Row로 그룹화
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${_selectedTime.hour < 12 ? "오전" : "오후"} '
                    '${(_selectedTime.hour > 12 ? _selectedTime.hour - 12 : _selectedTime.hour).toString().padLeft(2, '0')}:'
                    '${_selectedTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
