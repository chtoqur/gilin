import 'package:flutter/cupertino.dart';
import '../core/storage/secure_storage.dart';

class TokenChecker {
  static Future<void> checkTokens() async {
    var accessToken = await SecureStorage.instance.read(key: 'accessToken');
    var refreshToken = await SecureStorage.instance.read(key: 'refreshToken');

    debugPrint('===== 토큰 상태 확인 =====');
    debugPrint('액세스 토큰: ${accessToken ?? "없음"}');
    debugPrint('리프레시 토큰: ${refreshToken ?? "없음"}');
    debugPrint('========================');
  }
}

// 사용 예시
void checkCurrentTokens() {
  TokenChecker.checkTokens();
}