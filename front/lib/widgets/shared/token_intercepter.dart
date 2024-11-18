import 'package:dio/dio.dart';
import '../../core/storage/secure_storage.dart';

Future<Dio> kakaoAuthDio() async {
  var dio = Dio(BaseOptions(
    baseUrl: 'https://k11a306.p.ssafy.io/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    contentType: 'application/json',
    validateStatus: (status) => true,
  ));

  SecureStorage storage = SecureStorage.instance;

  dio.interceptors.clear();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      var accessToken = await storage.read(key: 'ACCESS_TOKEN');
      print("ACCESS_TOKEN: $accessToken");

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      return handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        var refreshToken = await storage.read(key: 'REFRESH_TOKEN');

        if (refreshToken != null) {
          try {
            var refreshDio = Dio();
            var response = await refreshDio.post(
              'https://k11a306.p.ssafy.io/api/user/reissue',
              data: {'refreshToken': refreshToken},
            );

            var newAccessToken = response.data['accessToken'];
            await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);

            error.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';

            var clonedRequest = await dio.request(
              error.requestOptions.path,
              options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              ),
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );

            return handler.resolve(clonedRequest);
          } catch (e) {
            await storage.deleteAll();
            return handler.reject(error);
          }
        }
      }
      return handler.next(error);
    },
  ));

  return dio;
}
