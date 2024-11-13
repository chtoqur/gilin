import '../../core/storage/secure_storage.dart';
import 'kakao_login.dart';

class LoginViewModel {
  final KakaoLogin _kakaoLogin;
  final SecureStorage _secureStorage;
  bool isLogined = false;

  LoginViewModel(this._kakaoLogin, this._secureStorage);

  Future<void> login() async {
    try {
      var kakaoData = await _kakaoLogin.login();

      var response = await _kakaoLogin.authenticateWithServer(kakaoData);

      await _secureStorage.write(
        key: 'accessToken',
        value: response['accessToken'],
      );
      await _secureStorage.write(
        key: 'refreshToken',
        value: response['refreshToken'],
      );

      isLogined = true;
    } catch (e) {
      isLogined = false;
      rethrow;
    }
  }
}