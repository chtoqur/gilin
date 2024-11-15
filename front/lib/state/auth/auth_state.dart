import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

// AuthState 정의
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User kakaoUser; // 카카오 사용자 정보 필드 추가

  AuthAuthenticated(this.kakaoUser); // 생성자 수정
}

class AuthUnauthenticated extends AuthState {}

class AuthNeedsRegistration extends AuthState {}
