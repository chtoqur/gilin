import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../core/storage/secure_storage.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User kakaoUser;

  AuthAuthenticated(this.kakaoUser);

  Future<String?> getAccessToken() async {
    return await SecureStorage.instance.read(key: 'ACCESS_TOKEN');
  }
}

class AuthUnauthenticated extends AuthState {}

class AuthNeedsRegistration extends AuthState {}
