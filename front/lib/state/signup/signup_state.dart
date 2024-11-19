import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final signupStateProvider =
    StateNotifierProvider<SignupStateNotifier, SignupState>((ref) {
  return SignupStateNotifier();
});
