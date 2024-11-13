class AuthModel {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String userId;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.userId,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresAt: DateTime.parse(json['expiresAt']),
      userId: json['userId'],
    );
  }
}