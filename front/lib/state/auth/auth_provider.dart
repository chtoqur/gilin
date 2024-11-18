import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../core/storage/secure_storage.dart';
import 'auth_state.dart';
import 'package:gilin/widgets/shared/token_intercepter.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final SecureStorage _secureStorage = SecureStorage.instance;

  AuthNotifier() : super(AsyncValue.data(AuthInitial())) {
    _checkStoredToken();
  }

  Future<void> signInWithKakao() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      var kakaoUser = await UserApi.instance.me();
      var token = await TokenManagerProvider.instance.manager.getToken();

      var accessToken = token?.accessToken;
      if (accessToken?.isNotEmpty == true) {
        await _secureStorage.write(key: 'ACCESS_TOKEN', value: accessToken!);
        print("AccessToken 저장됨: $accessToken");
      }

      var refreshToken = token?.refreshToken;
      if (refreshToken?.isNotEmpty == true) {
        await _secureStorage.write(key: 'REFRESH_TOKEN', value: refreshToken!);
        print("RefreshToken 저장됨: $refreshToken");
      }

      var dio = await kakaoAuthDio();

      var storedAccessToken = await _secureStorage.read(key: 'ACCESS_TOKEN');
      var storedRefreshToken = await _secureStorage.read(key: 'REFRESH_TOKEN');

      if (storedAccessToken == null || storedRefreshToken == null ||
          storedAccessToken.isEmpty || storedRefreshToken.isEmpty) {
        throw Exception('필수 토큰이 없습니다');
      }

      print("AccessToken: $storedAccessToken");
      print("RefreshToken: $storedRefreshToken");

      var response = await dio.post(
        'https://k11a306.p.ssafy.io/api/user/login',
        data: {
          "oAuthType": "KAKAO",
          "accessToken": storedAccessToken,
          "refreshToken": storedRefreshToken,
        },
      );

      if (response.statusCode == 200) {
        state = AsyncValue.data(AuthAuthenticated(kakaoUser));
      } else {
        throw Exception('API 요청이 실패했습니다');
      }
    } catch (error, stackTrace) {
      print('카카오 로그인 실패: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
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
      var token = await _secureStorage.read(key: 'ACCESS_TOKEN');
      if (token?.isNotEmpty == true) {
        await UserApi.instance.accessTokenInfo();
        var kakaoUser = await UserApi.instance.me();
        state = AsyncValue.data(AuthAuthenticated(kakaoUser));
      } else {
        state = AsyncValue.data(AuthUnauthenticated());
      }
    } catch (e) {
      print('토큰 확인 실패: $e');
      state = AsyncValue.data(AuthUnauthenticated());
    }
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: 'ACCESS_TOKEN');
  }

  Future<void> refreshToken() async {
    try {
      var token = await TokenManagerProvider.instance.manager.getToken();
      var accessToken = token?.accessToken;

      if (accessToken?.isNotEmpty == true) {
        print("새로운 AccessToken: $accessToken");
        await _secureStorage.write(key: 'ACCESS_TOKEN', value: accessToken!);
      } else {
        throw Exception('새로운 액세스 토큰이 없습니다');
      }
    } catch (e) {
      print('토큰 갱신 실패: $e');
      throw Exception('토큰 갱신에 실패했습니다');
    }
  }
}