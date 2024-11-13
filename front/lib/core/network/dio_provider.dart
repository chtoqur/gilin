import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  var dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-api-url.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  // 인터셉터 추가
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        var token = await SecureStorage.instance.read(key: 'accessToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // 토큰 갱신 로직
          try {
            var refreshToken = await SecureStorage.instance.read(key: 'refreshToken');
            if (refreshToken != null) {
              // 토큰 갱신 로직 구현
              // ...
            }
          } catch (e) {
            // 로그아웃 처리
            await SecureStorage.instance.deleteAll();
          }
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});