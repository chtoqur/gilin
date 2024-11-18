import 'package:flutter/material.dart';

class ArrivalTimeWidget extends StatelessWidget {
  final double progress;
  final double size;
  final DateTime endTime;

  const ArrivalTimeWidget({
    Key? key,
    required this.progress,
    this.size = 100,
    required this.endTime,
  }) : super(key: key);

  Color _getProgressColor(double progress) {
    if (progress <= 0.4) return Colors.green;
    if (progress <= 0.7) return Colors.yellow;
    return Colors.red;
  }

  String _getRemainingTime() {
    var now = DateTime.now();
    var remaining = endTime.difference(now);

    // 남은 시간이 음수면 '00:00'을 반환
    if (remaining.isNegative) {
      return '00:00';
    }

    var minutes = remaining.inMinutes;
    var seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: CircleTimerPainter(
              progress: progress,
              progressColor: _getProgressColor(progress),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 시간 표시
                Text(
                  _getRemainingTime(),
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 도착 예정 시간 표시
                Text(
                  '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: size * 0.16,
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
}

class CircleTimerPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  CircleTimerPainter({
    required this.progress,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var radius = size.width / 2;

    // 배경 원
    var bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(center, radius, bgPaint);

    // 진행 원
    var progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.141592 / 180),
      -360 * progress * (3.141592 / 180),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
