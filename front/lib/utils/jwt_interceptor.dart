import 'package:dio/dio.dart';

import '../auth/repository/auth_repository.dart';
import '../core/storage/secure_storage.dart';
import '../services/navigation_service.dart';

class JwtInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final AuthRepository _authRepository;

  JwtInterceptor(this._secureStorage, this._authRepository);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await _secureStorage.read(key: 'accessToken');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        var refreshToken = await _secureStorage.read(key: 'refreshToken');
        if (refreshToken != null) {
          var newTokens = await _authRepository.refreshToken(refreshToken);

          // 원래 요청 재시도
          var opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
          var response = await Dio().fetch(opts);
          return handler.resolve(response);
        }
      } catch (e) {
        await _handleLogout();
      }
    }
    return handler.next(err);
  }

  Future<void> _handleLogout() async {
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'refreshToken');
    // 네비게이션 서비스를 통한 로그아웃 처리
    await NavigationService.instance.navigateToLogin();
  }
}