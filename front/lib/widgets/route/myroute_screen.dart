import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gilin/widgets/route/route_item.dart';

class MyrouteScreen extends StatelessWidget {
  const MyrouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          const Center(
            child: SizedBox(
                width: 372,
                height: 23,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '내 경로 2', // 추후 수정: 목록 count
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '추가',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF979797)),
                        ),
                        Gap(3),
                        VerticalDivider(
                          width: 15,
                          thickness: 1,
                          indent: 4,
                          endIndent: 4,
                          color: Color(0xFF979797),
                        ),
                        Gap(3),
                        Text(
                          '편집',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF979797)),
                        ),
                      ],
                    )
                  ],
                )),
          ),
          const Gap(10),
          const Divider(
            color: Color(0xFFC7C5C5),
            thickness: 1,
            indent: 4, // 좌측 여백
            endIndent: 4, // 우측 여백
          ),
          const Gap(10),
          SizedBox(
            height: 300,
            child: ListView.separated(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  var datas = [
                    {
                      'from': '서울 강남구 테헤란로 201-2 긴 주소명 테스트',
                      'to': '하계역 7호선 긴 주소명 테스트 긴 주소명 테스트'
                    },
                    {'from': '강남역 2호선 긴 주소명 테스트 긴 주소명 테스트', 'to': '오무사'}
                  ];
                  var data = datas[index];
                  return RouteItem(
                      from: data['from'] ?? '', to: data['to'] ?? '');
                },
                separatorBuilder: (context, index) => const Gap(20),
                itemCount: 2),
          ),
        ],
      ),
    );
  }
}
