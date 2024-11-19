class Destination {
  final String iconPath;
  final String name;
  final String address;
  final String arrivalTime;
  final double x;  // 경도 (longitude)
  final double y;  // 위도 (latitude)

  const Destination({
    required this.iconPath,
    required this.name,
    required this.address,
    required this.arrivalTime,
    required this.x,
    required this.y,
  });
}
