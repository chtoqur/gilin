class LocalSearchResult {
  final String title;
  final String category;
  final String description;
  final String address;
  final String roadAddress;
  final int mapx;
  final int mapy;

  LocalSearchResult({
    required this.title,
    required this.category,
    required this.description,
    required this.address,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
  });

  factory LocalSearchResult.fromJson(Map<String, dynamic> json) {
    return LocalSearchResult(
      title: json['title']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      roadAddress: json['roadAddress'] ?? '',
      mapx: json['mapx'] != null ? int.parse(json['mapx'].toString()) : 0,
      mapy: json['mapy'] != null ? int.parse(json['mapy'].toString()) : 0,
    );
  }
}
