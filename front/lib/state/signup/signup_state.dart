import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/storage/secure_storage.dart';

class SignupState {
  final String nickname;
  final String gender;
  final String ageGroup;

  SignupState({
    this.nickname = '',
    this.gender = 'none',
    this.ageGroup = '선택 안함',
  });

  SignupState copyWith({
    String? nickname,
    String? gender,
    String? ageGroup,
  }) {
    return SignupState(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
    );
  }
}

class SignupStateNotifier extends StateNotifier<SignupState> {
  SignupStateNotifier() : super(SignupState());

  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateAgeGroup(String ageGroup) {
    state = state.copyWith(ageGroup: ageGroup);
  }


  Future<String> fetchKakaoNickname() async {
    var storage = SecureStorage.instance;
    var dio = Dio(BaseOptions(
      baseUrl: 'https://kapi.kakao.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));

    try {
      String? accessToken = await storage.read(key: 'ACCESS_TOKEN');

      if (accessToken == null) {
        throw Exception('액세스 토큰이 없습니다.');
      }


      var response = await dio.get(
        '/v2/user/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        var nickname = response.data['properties']['nickname'] as String?;
        return nickname ?? '닉네임 없음';
      } else {
        throw Exception('닉네임을 가져오지 못했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('닉네임 가져오기 에러: $e');
      throw Exception('닉네임을 가져오는 중 오류가 발생했습니다.');
    }
  }
}


final signupStateProvider =
StateNotifierProvider<SignupStateNotifier, SignupState>((ref) {
  return SignupStateNotifier();
});
