import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../widgets/mypage/place_card.dart';

class MypageScreen extends StatelessWidget {
  MypageScreen({super.key});

  static const List<Map<String, String>> menuItems = [
    {'title': '내 정보 변경', 'route': '/profile'},
    {'title': '알림 설정', 'route': '/alert'},
    {'title': '내 장소/경로 수정', 'route': '/payment'},
    {'title': '회원 탈퇴', 'route': '/support'},
  ];

  // 추후 실제 데이터로 변경
  final List<Place> placeList = [
    Place(name: '집', address: '서울 강남구 삼성로 99길 14 긴 문자열 테스트'),
    Place(name: '회사', address: '경기 화성시 삼성전자로 1'),
    Place(name: '멀티캠퍼스', address: '서울 강남구 테헤란로 212'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 358,
              height: 325,
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 25,
                        child: Text(
                          '지각대마왕님, 안녕하세요!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Gap(1),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'latemawang@gmail.com',
                          style: TextStyle(
                            color: Color(0xFF6E6E6E),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),

                  // 내 장소 섹션
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '나의 장소',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '전체보기',
                            style: TextStyle(
                              color: Color(0xFF6E6E6E),
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Gap(15),
                      PlaceList(
                        places: placeList,
                        onEdit: (place) {
                          // 편집 로직
                          print('편집: ${place.name}');
                        },
                        onDelete: (place) {
                          // 삭제 로직
                          print('삭제: ${place.name}');
                        },
                        onAdd: () {
                          // 추가 로직
                          print('새로운 장소 추가');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Expanded(  // 전체 영역을 Expanded로 감싸기
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(  // Column 추가
                  children: [
                    Expanded(  // ListView를 Expanded로 감싸서 남은 공간 차지
                      child: SingleChildScrollView(  // SingleChildScrollView로 변경
                        child: Column(  // 세로 스크롤을 위한 Column
                          children: [
                            ListView.separated(
                              shrinkWrap: true,  // SingleChildScrollView 내부에서는 필요
                              physics: const NeverScrollableScrollPhysics(),  // 부모 스크롤 사용
                              itemCount: menuItems.length,
                              separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                              itemBuilder: (context, index) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context,
                                        menuItems[index]['route']!
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        menuItems[index]['title']!,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 로그아웃 버튼은 항상 하단에 고정
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(
                            color: Color(0xFF6E6E6E),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
