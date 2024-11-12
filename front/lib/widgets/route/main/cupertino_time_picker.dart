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
    var now = DateTime.now();
    // 현재 분을 5의 배수로 조정
    var roundedMinutes = (now.minute ~/ 5) * 5;
    var initTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      roundedMinutes,
    );

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
        use24hFormat: false,
        minuteInterval: 5,
      ),
    );
  }
}