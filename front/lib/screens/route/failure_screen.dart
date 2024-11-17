import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            height: screenSize.height * 0.4, // 화면 높이의 40% 정도를 차지
            child: Lottie.asset(
              'assets/lottie/failure.json',
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),

          Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              )
          ),

          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Spacer(flex: 3), // 위쪽 공간 더 늘림

                    const Text(
                      '수고하셨어요',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      '다음 여정을 위해 부족했던 점을 알려주세요.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              '의견 제출하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: const Color(0xFF463C33),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 3), // 아래쪽 여백
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}