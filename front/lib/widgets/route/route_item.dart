import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class RouteItem extends StatelessWidget {
  final String from;
  final String to;

  const RouteItem({
    Key? key,
    required this.from,
    required this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
          padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                'assets/images/icons/road_2.svg',
                width: 20,
                height: 20,
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  from,
                  overflow: TextOverflow.ellipsis, // 말줄임표 처리
                  maxLines: 1, // 한 줄로 표시
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ),
              const Gap(5),
              const Icon(Icons.arrow_right_alt,
                  size: 20, color: Color(0xFF989898)),
              const Gap(5),
              Expanded(
                child: Text(
                  to,
                  overflow: TextOverflow.ellipsis, // 말줄임표 처리
                  maxLines: 1, // 한 줄로 표시
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
