import 'package:flutter/cupertino.dart';
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

      // 카카오에서 발급받은 토큰 정보 가져오기
      var token = await TokenManagerProvider.instance.manager.getToken();
      if (token != null) {
        await _secureStorage.write(key: 'ACCESS_TOKEN', value: token.accessToken ?? '');
        await _secureStorage.write(key: 'REFRESH_TOKEN', value: token.refreshToken ?? '');

        print("AccessToken 저장됨: ${token.accessToken}");
        print("RefreshToken 저장됨: ${token.refreshToken}");
      }

      // authDio 인터셉터 호출
      var dio = await kakaoAuthDio();

      // 저장된 토큰 값 불러오기
      final accessToken = await _secureStorage.read(key: 'ACCESS_TOKEN') ?? '';
      final refreshToken = await _secureStorage.read(key: 'REFRESH_TOKEN') ?? '';

      // 디버깅: 불러온 토큰 값 출력
      print("AccessToken: $accessToken");
      print("RefreshToken: $refreshToken");

      // 예제 API 요청 - 필요에 맞게 URL 변경
      var response = await dio.post(
        'https://k11a306.p.ssafy.io/api/user/login',
        data: {
          "oAuthType": "KAKAO",
          "accessToken": accessToken,
          "refreshToken": refreshToken,
        },
      );

      if (response.statusCode == 200) {
        state = AsyncValue.data(AuthAuthenticated(kakaoUser));
      } else {
        throw Exception('API 요청 실패');
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
      await _secureStorage.deleteAll(); // 모든 토큰 정보 삭제
      state = AsyncValue.data(AuthUnauthenticated());
    } catch (e, stackTrace) {
      print('로그아웃 실패: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> _checkStoredToken() async {
    try {
      var token = await _secureStorage.read(key: 'ACCESS_TOKEN');
      if (token != null) {
        var tokenInfo = await UserApi.instance.accessTokenInfo();
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

  // accessToken 가져오기 메서드
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'ACCESS_TOKEN');
  }

  // 토큰 갱신 메서드
  Future<void> refreshToken() async {
    try {
      var token = await TokenManagerProvider.instance.manager.getToken();
      if (token != null) {
        // 새로 갱신된 토큰을 SecureStorage에 저장
        print("New AccessToken: ${token.accessToken}"); // 디버깅
        await _secureStorage.write(key: 'ACCESS_TOKEN', value: token.accessToken ?? '');
      }
    } catch (e) {
      print('토큰 갱신 실패: $e');
      throw Exception('토큰 갱신에 실패했습니다.');
    }
  }
}
