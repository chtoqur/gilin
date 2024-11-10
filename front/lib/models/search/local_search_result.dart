class LocalSearchResult {
  final String title;
  final String category;
  final String address;
  final String roadAddress;
  final double x;
  final double y;
  final String placeId;

  LocalSearchResult({
    required this.title,
    required this.category,
    required this.address,
    required this.roadAddress,
    required this.x,
    required this.y,
    required this.placeId,
  });

  factory LocalSearchResult.fromKakaoJson(Map<String, dynamic> json) {
    return LocalSearchResult(
      title: json['place_name']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
      category: json['category_name'] ?? '',
      address: json['address_name'] ?? '',
      roadAddress: json['road_address_name'] ?? '',
      x: double.tryParse(json['x'] ?? '0') ?? 0,
      y: double.tryParse(json['y'] ?? '0') ?? 0,
      placeId: json['id'] ?? '',
    );
  }
}
