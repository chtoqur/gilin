import 'package:dio/dio.dart';

class UserService {
  final Dio _dio;
  static const String baseUrl = 'https://k11a306.p.ssafy.io/api';

  UserService() : _dio = Dio();

}