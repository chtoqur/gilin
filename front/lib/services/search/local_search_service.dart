import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/search/local_search_result.dart';

class LocalSearchService {
  static const String baseUrl = 'https://openapi.naver.com/v1/search/local.json';
  final String clientId;
  final String clientSecret;

  LocalSearchService({
    required this.clientId,
    required this.clientSecret,
  });

  Future<List<LocalSearchResult>> searchLocal({
    required String query,
    int display = 5,
    int start = 1,
    String sort = 'random',
  }) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final uri = Uri.parse('$baseUrl?query=$encodedQuery&display=$display&start=$start&sort=$sort');

      if (kDebugMode) {
        print('Requesting URL: $uri');
      }

      final response = await http.get(
        uri,
        headers: {
          'X-Naver-Client-Id': clientId,
          'X-Naver-Client-Secret': clientSecret,
          'Content-Type': 'application/json',
        },
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('items')) {
          final List<dynamic> items = data['items'];
          return items.map((item) => LocalSearchResult.fromJson(item)).toList();
        }
      }

      // 응답이 200이 아니거나 items가 없는 경우 빈 리스트 반환
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error in searchLocal: $e');
      }
      // 에러 발생 시 빈 리스트 반환
      return [];
    }
  }
}