import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gilin/widgets/route/location_item.dart';

class MyplaceScreen extends StatelessWidget {
  const MyplaceScreen({Key? key}) : super(key: key);

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
                      '전체 목록 4', // 추후 수정: 목록 count
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
                  var titles = ['멀티캠퍼스 역삼', '서영이네', '선릉역 2번 출구', '본가'];
                  return LocationItem(title: titles[index], onTap: () {});
                },
                separatorBuilder: (context, index) => const Gap(20),
                itemCount: 4),
          )
        ],
      ),
    );
  }
}
