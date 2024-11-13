import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../core/storage/secure_storage.dart';
import 'auth_state.dart';
import 'package:dio/dio.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier(SecureStorage.instance);
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final SecureStorage _storage;
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://k11a306.p.ssafy.io',  // 백엔드 서버 URL
    headers: {'Content-Type': 'application/json'},
  ));

  AuthNotifier(this._storage) : super(const AsyncValue.data(AuthInitial())) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      var token = await _storage.read(key: 'accessToken');
      if (token != null) {
        var user = await UserApi.instance.me();
        state = AsyncValue.data(AuthAuthenticated(user));
      } else {
        state = const AsyncValue.data(AuthUnauthenticated());
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signInWithKakao() async {
    try {
      state = const AsyncValue.loading();

      await _storage.deleteAll();
      try {
        await UserApi.instance.unlink();
      } catch (e) {
        print('기존 연결 해제 실패: $e');
      }

      OAuthToken kakaoToken;
      if (await isKakaoTalkInstalled()) {
        kakaoToken = await UserApi.instance.loginWithKakaoTalk();
      } else {
        kakaoToken = await UserApi.instance.loginWithKakaoAccount();
      }
      print('카카오 토큰 발급 성공: ${kakaoToken.accessToken}');

      var user = await UserApi.instance.me();
      print('카카오 사용자 정보: ${user.id}');

      var response = await _dio.post(
        '/user/login',
        data: {
          'oAuthType': 'KAKAO',
          'accessToken': kakaoToken.accessToken,
        },
      );
      print('서버 응답: ${response.data}');

      await _storage.write(key: 'accessToken', value: response.data['accessToken']);
      await _storage.write(key: 'refreshToken', value: response.data['refreshToken']);

      state = AsyncValue.data(AuthAuthenticated(user));
    } on KakaoAuthException catch (e) {
      print('카카오 인증 에러: ${e.error}');
      if (e.error == 'invalid_grant') {
        await _storage.deleteAll();
        state = const AsyncValue.data(AuthUnauthenticated());
      }
      rethrow;
    } catch (e, stack) {
      print('기타 에러: $e');
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _storage.deleteAll();
      state = const AsyncValue.data(AuthUnauthenticated());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}