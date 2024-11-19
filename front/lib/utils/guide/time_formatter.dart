class TimeFormatter {
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes분';
    }
    var hours = minutes ~/ 60;
    var remainingMinutes = minutes % 60;
    return '$hours시간 $remainingMinutes분';
  }

  static String formatArrivalTime(int totalMinutes) {
    var now = DateTime.now();
    var arrival = now.add(Duration(minutes: totalMinutes));
    return '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')} 도착 예정';
  }
}

// utils/formatters/distance_formatter.dart
class DistanceFormatter {
  static String format(double meters) {
    return meters >= 1000
        ? '${(meters / 1000).toStringAsFixed(1)}km'
        : '${meters.toInt()}m';
  }
}
