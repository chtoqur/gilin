import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gilin/widgets/shared/cupertino_radio.dart';
import 'package:go_router/go_router.dart';

import 'package:dio/dio.dart'; // Dio 패키지 추가
import '../../state/auth/auth_provider.dart';
import '../../state/auth/auth_state.dart';
import '../../state/signup/signup_state.dart';
import '../../widgets/shared/cupertino_radio.dart';

class SignupStep1Screen extends ConsumerStatefulWidget {
  const SignupStep1Screen({super.key});

  @override
  ConsumerState<SignupStep1Screen> createState() => _SignupStep1ScreenState();
}

class _SignupStep1ScreenState extends ConsumerState<SignupStep1Screen> {
  final TextEditingController _nicknameController = TextEditingController();
  final List<String> ageGroups = [
    '선택 안함',
    '10대',
    '20대',
    '30대',
    '40대',
    '50대',
    '60대',
    '70대',
    '80대 이상'
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController.text = "길싸피";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(signupStateProvider.notifier)
          .updateNickname(_nicknameController.text);
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _submitAdditionalInfo() async {
    var signupState = ref.read(signupStateProvider);
    try {
      var authNotifier = ref.read(authProvider.notifier);
      var accessToken = await authNotifier.getAccessToken();

      if (accessToken != null) {
        // gender 값을 "M" 또는 "F"로 변환
        String? gender;
        if (signupState.gender == "male") {
          gender = "M";
        } else if (signupState.gender == "female") {
          gender = "F";
        }

        // ageGroup에서 숫자만 추출
        int ageGroup = int.tryParse(
                signupState.ageGroup.replaceAll(RegExp(r'[^0-9]'), '')) ??
            0;

        var response = await Dio().post(
          'https://k11a306.p.ssafy.io/api/user/register',
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: {
            "nickname": signupState.nickname,
            "gender": gender,
            "ageGroup": ageGroup,
          },
        );

        if (response.statusCode == 200) {
          print('회원가입 완료');
        } else {
          print('서버 응답: ${response.data}');
          throw Exception('회원가입 실패');
        }
      }
    } catch (e) {
      print('회원가입 요청 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 중 오류가 발생했습니다.')),
      );
    }
  }

  void _showAgePicker() {
    var signupState = ref.read(signupStateProvider);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(
              initialItem: ageGroups.indexOf(signupState.ageGroup),
            ),
            onSelectedItemChanged: (int selectedItem) {
              ref
                  .read(signupStateProvider.notifier)
                  .updateAgeGroup(ageGroups[selectedItem]);
            },
            children: List<Widget>.generate(ageGroups.length, (int index) {
              return Center(child: Text(ageGroups[index]));
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authProvider);

    if (authState is AsyncData<AuthAuthenticated>) {
      var nickname = authState.value.kakaoUser.kakaoAccount?.profile?.nickname;
      if (nickname != null && _nicknameController.text.isEmpty) {
        _nicknameController.text = nickname;
        ref.read(signupStateProvider.notifier).updateNickname(nickname);
      }
    }

    var signupState = ref.watch(signupStateProvider);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xffF8F5F0),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 45, horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '닉네임을 입력해주세요',
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff463C33)),
                      ),
                      const Gap(5),
                      const Text(
                        '마이페이지에서 수정할 수 있어요',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff463C33),
                        ),
                      ),
                      const Gap(20),
                      CupertinoTextField(
                        controller: _nicknameController,
                        placeholder: '닉네임을 입력하세요',
                        style: const TextStyle(fontSize: 16),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: CupertinoColors.systemGrey4),
                          borderRadius: BorderRadius.circular(8),
                          color: CupertinoColors.white,
                        ),
                        onChanged: (value) {
                          ref
                              .read(signupStateProvider.notifier)
                              .updateNickname(value);
                        },
                      ),
                      const Gap(40),
                      const Text(
                        '성별/연령대를 선택해주세요',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff463C33),
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        '입력한 정보는 맞춤형 서비스를 위해 사용되며\n외부에 공개되지 않습니다',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff463C33),
                        ),
                      ),
                      const Gap(20),
                      Row(
                        children: [
                          CupertinoRadioItem<String>(
                            value: 'male',
                            groupValue: signupState.gender,
                            onChanged: (value) {
                              if (value != null) {
                                ref
                                    .read(signupStateProvider.notifier)
                                    .updateGender(value);
                              }
                            },
                            label: '남성',
                          ),
                          const Gap(30),
                          CupertinoRadioItem<String>(
                            value: 'female',
                            groupValue: signupState.gender,
                            onChanged: (value) {
                              if (value != null) {
                                ref
                                    .read(signupStateProvider.notifier)
                                    .updateGender(value);
                              }
                            },
                            label: '여성',
                          ),
                          const Gap(30),
                          CupertinoRadioItem<String>(
                            value: 'none',
                            groupValue: signupState.gender,
                            onChanged: (value) {
                              if (value != null) {
                                ref
                                    .read(signupStateProvider.notifier)
                                    .updateGender(value);
                              }
                            },
                            label: '선택 안 함',
                          ),
                        ],
                      ),
                      const Gap(23),
                      GestureDetector(
                        onTap: _showAgePicker,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CupertinoColors.systemGrey4),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                signupState.ageGroup,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                color: CupertinoColors.systemGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xffF8F5F0),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                          primaryColor: Color(0xFF669358)),
                      child: CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        borderRadius: BorderRadius.zero,
                        onPressed: signupState.nickname.isEmpty
                            ? null
                            : () {
                                _submitAdditionalInfo;
                                context.push('/signup_step2');
                              },
                        disabledColor: const Color(0xFFD9D9D9),
                        child: Text(
                          '회원가입 완료',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: signupState.nickname.isEmpty
                                ? const Color(0xFF757575)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
