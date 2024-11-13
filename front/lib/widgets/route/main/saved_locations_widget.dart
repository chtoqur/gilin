import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SavedLocationsWidget extends StatelessWidget {
  const SavedLocationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            double containerWidth = (constraints.maxWidth / 2) - 10;
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BookmarkContainer(
                  title: '집',
                  iconData: 'home',
                  width: containerWidth,
                ),
                const Gap(20),
                BookmarkContainer(
                  title: '회사/학교',
                  iconData: 'company',
                  width: containerWidth,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

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
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width * 0.35,
            height: width * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/streamline/$iconData.svg',
                width: width * 0.2,
                height: width * 0.2,
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  '서울특별시 노원구 석계로',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}