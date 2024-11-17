import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

class SuccessScreen extends StatelessWidget {
  // final String backgroundImageUrl;  // 배경 이미지 URL

  const SuccessScreen({
    Key? key,
    // required this.backgroundImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 배경 이미지
          // Positioned.fill(
          //   child: Image.network(
          //     // backgroundImageUrl,
          //     // fit: BoxFit.cover,
          //   ),
          // ),
          // 블러 처리
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

          // Lottie 애니메이션
          Positioned.fill(
            child: Lottie.asset(
              'assets/lottie/success.json',
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),

          // 컨텐츠
          Positioned.fill(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '수고하셨어요!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    '다음 여정도 길인과 함께해요.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8EAAB),
                        foregroundColor: const Color(0xFF463C33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}