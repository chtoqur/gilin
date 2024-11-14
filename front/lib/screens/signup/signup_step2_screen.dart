import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SignupStep2Screen extends ConsumerStatefulWidget {
  const SignupStep2Screen({super.key});

  @override
  ConsumerState<SignupStep2Screen> createState() => _SignupStep2ScreenState();
}

class _SignupStep2ScreenState extends ConsumerState<SignupStep2Screen> {
  String selectedType = '집';  // 선택된 장소 유형

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '자주가는 장소를\n등록해보세요',
                        style: TextStyle(
                          color: Color(0xFF463C33),
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(15),
                      const Text(
                        '집이나 회사/학교 주소를 등록하면 빠른 길찾기가 가능해요',
                        style: TextStyle(
                          color: Color(0xFF74695E),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(30),
                      // 장소 유형 선택 버튼들
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _buildTypeButton('집'),
                            _buildTypeButton('회사'),
                            _buildTypeButton('학교'),
                            _buildTypeButton('기타'),
                          ],
                        ),
                      ),
                      const Gap(20),
                      // 장소 검색 필드 추가 예정
                    ],
                  ),
                ),
              ),
            ),
            // 하단 버튼
            Container(
              width: double.infinity,
              height: 72,
              color: const Color(0xFF669358),
              child: TextButton(
                onPressed: () {
                  // 나중에 하기 - 메인 화면으로 이동
                  Navigator.pushReplacementNamed(context, '/route');
                },
                child: const Text(
                  '다음에 할게요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type) {
    bool isSelected = selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = type),
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE4DBCF) : Colors.transparent,
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type == '집' ? Icons.home :
                type == '회사' ? Icons.business :
                type == '학교' ? Icons.school : Icons.place,
                size: 16,
              ),
              const Gap(6),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}