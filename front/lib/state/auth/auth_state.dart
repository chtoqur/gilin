import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// 회원가입 필요 상태 추가
class AuthNeedsRegistration extends AuthState {
  final OAuthToken token;
  final User kakaoUser;

  const AuthNeedsRegistration({
    required this.token,
    required this.kakaoUser,
  });
}