import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';

class KakaoLogin {
  final Dio _dio;

  KakaoLogin({required Dio dio}) : _dio = dio;

  Future<Map<String, dynamic>> login() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      User user = await UserApi.instance.me();

      return {
        'kakaoId': user.id.toString(),
        'email': user.kakaoAccount?.email,
        'nickname': user.kakaoAccount?.profile?.nickname,
        'accessToken': token.accessToken,
        // 최신 버전에서는 expiresAt 사용
        'expiresAt': token.expiresAt,
      };
    } catch (error) {
      throw Exception('카카오 로그인 실패: $error');
    }
  }

  // 토큰 갱신 메소드 수정
  Future<OAuthToken> refreshAccessToken() async {
    try {
      // refreshToken 파라미터 없이 호출
      return await AuthApi.instance.refreshToken();
    } catch (e) {
      throw Exception('토큰 갱신 실패: $e');
    }
  }

  Future<Map<String, dynamic>> authenticateWithServer(Map<String, dynamic> kakaoData) async {
    try {
      var response = await _dio.post(
        '/api/auth/kakao',
        data: kakaoData,
      );

      return response.data;
    } catch (error) {
      throw Exception('서버 인증 실패: $error');
    }
  }
}