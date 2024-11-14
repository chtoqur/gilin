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
    baseUrl: 'https://k11a306.p.ssafy.io/api',
    headers: {'Content-Type': 'application/json'},
  ));

  AuthNotifier(this._storage) : super(const AsyncValue.data(AuthInitial()));

  Future signInWithKakao() async {
    try {
      state = const AsyncValue.loading();

      // 카카오 로그인으로 토큰 받기
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      User kakaoUser = await UserApi.instance.me();

      try {
        // 로그인 시도
        var response = await _dio.post(
          '/user/login',
          data: {
            'oAuthType': 'KAKAO',
            'accessToken': token.accessToken,
            'refreshToken': token.refreshToken,
          },
        );

        await _storage.write(key: 'accessToken', value: response.data['accessToken']);
        await _storage.write(key: 'refreshToken', value: response.data['refreshToken']);

        var user = User.fromJson(response.data);
        state = AsyncValue.data(AuthAuthenticated(user));

      } catch (e) {
        if (e is DioException && e.response?.statusCode == 401) {
          print('회원가입이 필요한 사용자입니다.');

          // 회원가입 API 호출 추가
          try {
            var registerResponse = await _dio.post(
              '/user/register',
              data: {
                'oAuthType': 'KAKAO',
                'accessToken': token.accessToken,
                'refreshToken': token.refreshToken,
                'name': kakaoUser.kakaoAccount?.profile?.nickname,
                'gender': 'none',  // SignupStep1Screen에서 업데이트
                'ageGroup': 0,     // SignupStep1Screen에서 업데이트
              },
            );

            // 회원가입 성공 시 토큰 저장
            await _storage.write(key: 'accessToken', value: registerResponse.data['accessToken']);
            await _storage.write(key: 'refreshToken', value: registerResponse.data['refreshToken']);

            // 추가 정보 입력을 위해 상태 변경
            state = AsyncValue.data(
              AuthNeedsRegistration(
                token: token,
                kakaoUser: kakaoUser,
              ),
            );
          } catch (registerError) {
            print('회원가입 실패: $registerError');
            rethrow;
          }
        } else {
          rethrow;
        }
      }
    } catch (e) {
      print('카카오 로그인/회원가입 실패: $e');
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      await UserApi.instance.logout();
      await _storage.deleteAll();
      state = const AsyncValue.data(AuthUnauthenticated());
    } catch (e, stack) {
      print('로그아웃 실패: $e');
      state = AsyncValue.error(e, stack);
    }
  }
}

