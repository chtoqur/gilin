import 'package:flutter/cupertino.dart';

class CupertinoTimePicker extends StatelessWidget {
  final void Function(DateTime) onDateTimeChanged;
  final String initTimeStr;

  const CupertinoTimePicker({
    Key? key,
    required this.onDateTimeChanged,
    required this.initTimeStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 현재 시간을 초기값으로 설정
    var initTime = DateTime.now();

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: CupertinoDatePicker(
        initialDateTime: initTime,
        onDateTimeChanged: onDateTimeChanged,
        mode: CupertinoDatePickerMode.time,
        use24hFormat: false, // 12시간 형식 사용
        minuteInterval: 1, // 분 간격 설정
      ),
    );
  }
}