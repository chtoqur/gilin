import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class BookmarkContainer extends StatelessWidget {
  final String title;
  final String iconData;
  final double width;

  const BookmarkContainer({
    Key? key,
    required this.title,
    required this.iconData,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width * 0.3,
            height: width * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/streamline/$iconData.svg',
                width: width * 0.15,
                height: width * 0.15,
              ),
            ),
          ),
          const Gap(5),
          Column(
            children: [],
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
