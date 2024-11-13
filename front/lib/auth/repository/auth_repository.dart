import 'package:dio/dio.dart';
import '../../core/storage/secure_storage.dart';
import '../model/token_model.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorage _secureStorage;

  AuthRepository(this._dio, this._secureStorage);

  Future<TokenModel> kakaoLogin(String kakaoToken) async {
    try {
      var response = await _dio.post(
        '/api/auth/kakao/callback',
        data: {'token': kakaoToken},
      );

      var tokenModel = TokenModel.fromJson(response.data);
      await _secureStorage.write(key: 'accessToken', value: tokenModel.accessToken);
      await _secureStorage.write(key: 'refreshToken', value: tokenModel.refreshToken);

      return tokenModel;
    } catch (e) {
      throw Exception('카카오 로그인 실패');
    }
  }

  Future<TokenModel> refreshToken(String refreshToken) async {
    try {
      var response = await _dio.post(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      var tokenModel = TokenModel.fromJson(response.data);
      await _secureStorage.write(key: 'accessToken', value: tokenModel.accessToken);

      return tokenModel;
    } catch (e) {
      throw Exception('토큰 갱신 실패');
    }
  }
}