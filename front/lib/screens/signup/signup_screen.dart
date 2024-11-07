import 'package:flutter/material.dart';
import 'package:gilin/widgets/login/login_text_field.dart';




// 로그인 UI
class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 16.0),
            LoginTextField(
              onSaved: (String? val) {},
              validator: (String? val) {},
              hintText: '인증 번호 입력',
            ),
            const SizedBox(height: 8.0),
            LoginTextField(
              obscureText: true,
              onSaved: (String? val) {},
              validator: (String? val) {},
              hintText: '비밀번호 입력',
            ),
            const SizedBox(height: 8.0),

            LoginTextField(
              obscureText: true,
              onSaved: (String? val) {},
              validator: (String? val) {},
              hintText: '비밀번호 확인',
            ),
            const SizedBox(height: 8.0),

            LoginTextField(
              onSaved: (String? val) {},
              validator: (String? val) {},
              hintText: '닉네임 입력',
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('계속하기'),
            ),

          ],
        ),
      ),
    );
  }
}