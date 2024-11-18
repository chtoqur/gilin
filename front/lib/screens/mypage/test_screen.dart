import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/route/arrival_time_provider.dart';
import 'package:gilin/widgets/route/arrival_time_widget.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(title: const Text('Circle Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ArrivalTimeWidget(size: 135),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //  현재 시간으로부터 n분 뒤로 설정
                ref.read(arrivalTimeProvider.notifier).state = ArrivalTime.fromMinutes(1);
              },
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}