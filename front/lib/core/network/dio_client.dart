import 'package:dio/dio.dart';
import '../../utils/api_config.dart';
import '../storage/secure_storage.dart';

class DioClient {
  late final Dio _dio;
  final SecureStorage _secureStorage;

  DioClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    _setupInterceptors();
  }
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          var token = await _secureStorage.read(key: 'accessToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              var refreshToken = await _secureStorage.read(key: 'refreshToken');
              if (refreshToken != null) {
                var response = await _dio.post(
                  ApiConfig.refreshEndpoint,
                  data: {'refreshToken': refreshToken},
                );

                var newToken = response.data['accessToken'];
                await _secureStorage.write(key: 'accessToken', value: newToken);

                // 원래 요청 재시도
                error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                return handler.resolve(await _dio.fetch(error.requestOptions));
              }
            } catch (e) {
              await _handleLogout();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }



  Future<void> _handleLogout() async {
    await _secureStorage.deleteAll();
  }
}