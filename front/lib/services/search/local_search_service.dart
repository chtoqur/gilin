import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/search/local_search_result.dart';

class LocalSearchService {
  static const String baseUrl =
      'https://dapi.kakao.com/v2/local/search/keyword.json';
  final String apiKey;

  LocalSearchService({
    required this.apiKey,
  });

  Future<List<LocalSearchResult>> searchLocal({
    required String query,
    int page = 1,
    int size = 15,
  }) async {
    try {
      var uri = Uri.parse(baseUrl).replace(queryParameters: {
        'query': query,
        'page': page.toString(),
        'size': size.toString(),
      });

      if (kDebugMode) {
        print('Requesting URL: $uri');
      }

      var response = await http.get(
        uri,
        headers: {
          'Authorization': 'KakaoAK $apiKey',
        },
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('documents')) {
          List<dynamic> items = data['documents'];
          return items.map((item) => LocalSearchResult.fromKakaoJson(item)).toList();
        }
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error in searchLocal: $e');
      }
      return [];
    }
  }
}