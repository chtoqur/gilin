import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../models/search/local_search_result.dart';
import '../../screens/guide/guide_preview_screen.dart';

//테스트용
import '../../utils/sample_data/route_samples.dart';  // 테스트 데이터 import

class SearchResultMapInfo extends StatelessWidget {
  final LocalSearchResult searchResult;
  final VoidCallback? onStartPressed;
  final VoidCallback? onEndPressed;

  const SearchResultMapInfo({
    Key? key,
    required this.searchResult,
    this.onStartPressed,
    this.onEndPressed,
  }) : super(key: key);

  String getMainCategory(String category) {
    return category.split('>')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16), // 좌우 패딩 최적화
      decoration: const BoxDecoration(
        color: Color(0xffF8F5F0),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 좌우 끝 정렬
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 왼쪽
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 6,
                  runSpacing: 3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      searchResult.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      getMainCategory(searchResult.category),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  searchResult.roadAddress,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const Gap(25),
          // 오른쪽 (아이콘)
          SizedBox(
            width: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GuidePreviewScreen(
                          selectedLocation: searchResult,
                          routeData: RouteSamples.seoulCityHallToGyeongbokgung,  // 테스트 데이터 전달
                        ),
                      ),
                    );
                  },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF463C33),
                    border: Border.all(color: const Color(0xFF463C33), width: 1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/icons/pin_x_mark.svg',
                      width: 60 * 0.65,
                      height: 60 * 0.65,
                    ),
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
