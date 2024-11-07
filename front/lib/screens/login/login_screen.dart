import 'package:flutter/material.dart';
import 'package:gilin/themes/color.dart';
import 'package:gilin/widgets/login/login_text_field.dart';

// 로그인 UI
class LoginScreenUI extends StatelessWidget {
  const LoginScreenUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/img/logo.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            const SizedBox(height: 16.0),
            LoginTextField(
              onSaved: (String? val) {},
              validator: (String? val) {
                return null; // null을 반환하면 유효성 검사 통과
              },
              hintText: '이메일 입력',
            ),
            const SizedBox(height: 8.0),
            LoginTextField(
              obscureText: true,
              onSaved: (String? val) {},
              validator: (String? val) {
                return null; // null을 반환하면 유효성 검사 통과
              },
              hintText: '비밀번호 입력',
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // 버튼을 눌렀을 때의 동작
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: seaGreen, // 버튼의 배경색
                foregroundColor: white, // 버튼의 텍스트 색상
              ),
              child: const Text('로그인'),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: 439,
              height: 18,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '아이디 찾기',
                    style: TextStyle(
                      color: Color(0xFF979797),
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      color: Color(0xFF979797),
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    '회원가입',
                    style: TextStyle(
                      color: Color(0xFFA38265),
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 16.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
