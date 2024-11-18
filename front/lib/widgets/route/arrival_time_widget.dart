import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gilin/state/route/arrival_time_provider.dart';

class ArrivalTimeWidget extends ConsumerStatefulWidget {
  final double size;

  const ArrivalTimeWidget({
    Key? key,
    this.size = 140,
  }) : super(key: key);

  @override
  ConsumerState<ArrivalTimeWidget> createState() => _ArrivalTimeWidgetState();
}

class _ArrivalTimeWidgetState extends ConsumerState<ArrivalTimeWidget> {
  Timer? _timer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    // 초기 타이머 설정
    _initializeTimer();
  }

  void _initializeTimer() {
    final arrivalTime = ref.read(arrivalTimeProvider);
    if (arrivalTime != null) {
      _startTimer(arrivalTime);
    }
  }

  // Provider 변경을 감지하고 타이머 재시작
  void _restartTimer() {
    final arrivalTime = ref.read(arrivalTimeProvider);
    if (arrivalTime != null) {
      setState(() {
        _progress = 0.0;  // 진행률 초기화
      });
      _startTimer(arrivalTime);
    }
  }

  void _startTimer(ArrivalTime arrivalTime) {
    _timer?.cancel();

    final totalDuration = arrivalTime.targetTime.difference(arrivalTime.startTime).inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      final now = DateTime.now();
      final elapsedDuration = now.difference(arrivalTime.startTime).inSeconds;

      setState(() {
        _progress = (elapsedDuration / totalDuration).clamp(0.0, 1.0);
      });
    });
  }

  String _getRemainingTime(DateTime targetTime) {
    final now = DateTime.now();
    final remaining = targetTime.difference(now);

    if (remaining.isNegative) return '00:00';

    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.4) return const Color(0xFFACC270);
    if (progress <= 0.7) return const Color(0xFFFFC65D);
    return const Color(0xFFFDA868);
  }

  @override
  Widget build(BuildContext context) {
    final arrivalTime = ref.watch(arrivalTimeProvider);

    // Provider 변경 감지 시 타이머 재시작
    ref.listen<ArrivalTime?>(arrivalTimeProvider, (previous, next) {
      if (next != null) {
        _restartTimer();
      }
    });

    if (arrivalTime == null) {
      return const SizedBox();
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: CircleTimerPainter(
              progress: _progress,
              progressColor: _getProgressColor(_progress),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getRemainingTime(arrivalTime.targetTime),
                  style: TextStyle(
                    fontSize: widget.size * 0.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${arrivalTime.targetTime.hour.toString().padLeft(2, '0')}:${arrivalTime.targetTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: widget.size * 0.16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// CircleTimerPainter 수정
class CircleTimerPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  CircleTimerPainter({
    required this.progress,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 내부 보더 원
    final innerBorderPaint = Paint()
      ..color = const Color(0xFFF8F5F0)  // 베이지색 보더
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;  // 얇은 보더

    canvas.drawCircle(center, radius - 6.0, innerBorderPaint);  // 프로그레스 바 안쪽에 그리기

    // 배경 원
    final bgPaint = Paint()
      ..color = const Color(0xFFACC270)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0;

    canvas.drawCircle(center, radius, bgPaint);

    // 남은 진행 부분
    final remainingPaint = Paint()
      ..color = const Color(0xFFF8F5F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.141592 / 180),
      360 * (1 - progress) * (3.141592 / 180),
      false,
      remainingPaint,
    );

    // 진행된 부분 (컬러)
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.141592 / 180),
      -360 * progress * (3.141592 / 180),
      false,
      progressPaint,
    );

    // 외부 보더 원 (선택사항)
    final outerBorderPaint = Paint()
      ..color = const Color(0xFFF8F5F0)  // 베이지색 보더
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;  // 얇은 보더

    canvas.drawCircle(center, radius + 6.0, outerBorderPaint);  // 프로그레스 바 바깥쪽에 그리기
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}