import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/route/arrival_time_provider.dart';
import 'package:gilin/widgets/route/arrival_time_widget.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(arrivalTimerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Circle Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.endTime != null)
              ArrivalTimeWidget(
                progress: state.progress,
                size: 120,
                endTime: state.endTime!,
              )
            else
              const Text('타이머가 설정되지 않았습니다'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var endTime = DateTime.now().add(const Duration(minutes: 10));
                ref.read(arrivalTimerProvider.notifier).startTimer(endTime);
              },
              child: const Text('Start 10min Timer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ref.read(arrivalTimerProvider.notifier).stopTimer();
              },
              child: const Text('Stop Timer'),
            ),
          ],
        ),
      ),
    );
  }
}