import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

part 'user_model.g.dart';

@JsonSerializable()
class AppUser {
  final String id;
  final String email;
  final String nickname;
  final String? profileImage;

  AppUser({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImage,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  factory AppUser.fromKakaoUser(kakao.User kakaoUser) {
    return AppUser(
      id: kakaoUser.id.toString(),
      email: kakaoUser.kakaoAccount?.email ?? '',
      nickname: kakaoUser.kakaoAccount?.profile?.nickname ?? '',
      profileImage: kakaoUser.kakaoAccount?.profile?.profileImageUrl,
    );
  }

  // 복사본 생성을 위한 copyWith 메서드
  AppUser copyWith({
    String? id,
    String? email,
    String? nickname,
    String? profileImage,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}