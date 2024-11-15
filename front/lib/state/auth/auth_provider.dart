import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthNotifier() : super(AsyncValue.data(AuthInitial())) {
    _checkStoredToken();
  }

  Future<void> signInWithKakao() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      var kakaoUser = await UserApi.instance.me();
      var token = await TokenManagerProvider.instance.manager.getToken();

      if (token != null) {
        await _secureStorage.write(key: 'accessToken', value: token.accessToken);
      }

      state = AsyncValue.data(AuthAuthenticated(kakaoUser));
    } catch (error, stackTrace) {
      print('카카오 로그인 실패: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    try {
      state = AsyncValue.loading();
      await UserApi.instance.logout();
      await _secureStorage.deleteAll();
      state = AsyncValue.data(AuthUnauthenticated());
    } catch (e, stackTrace) {
      print('로그아웃 실패: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> _checkStoredToken() async {
    try {
      var token = await _secureStorage.read(key: 'accessToken');
      if (token != null) {
        var tokenInfo = await UserApi.instance.accessTokenInfo();
        if (tokenInfo != null) {
          var kakaoUser = await UserApi.instance.me();
          state = AsyncValue.data(AuthAuthenticated(kakaoUser));
        } else {
          state = AsyncValue.data(AuthUnauthenticated());
        }
      } else {
        state = AsyncValue.data(AuthUnauthenticated());
      }
    } catch (e) {
      print('토큰 확인 실패: $e');
      state = AsyncValue.data(AuthUnauthenticated());
    }
  }

  // accessToken 가져오기 메서드
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }
}
