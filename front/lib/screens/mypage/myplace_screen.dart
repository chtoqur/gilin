import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class Place {
  final String name;
  final String address;
  final String icon;
  final bool isEmpty;

  Place({
    required this.name,
    required this.address,
    required this.icon,
    this.isEmpty = false,
  });
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier()
      : super([
    Place(
      name: '집',
      address: '서울특별시 강남구 삼성로 99길 14',
      icon: 'home',
    ),
    Place(
      name: '회사',
      address: '서울 강남구 테헤란로 212 긴 주소 테스트용',
      icon: 'company',
    ),
    Place(
      name: '라티움',
      address: '인천 중구 영종대로 106 1층 (운서동)',
      icon: 'place',
    ),
  ]);

  void addPlace(Place place) {
    state = [...state, place];
  }

  void removePlace(int index) {
    state = [...state]..removeAt(index);
  }
}

class MyplaceScreen extends ConsumerWidget {
  const MyplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xffF8F5F0),
        border: null,
        middle: Text(
          '내 장소',
          style: TextStyle(
            color: Color(0xff463C33),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: Color(0xff463C33),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.push('/add_myplace');
              },
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5ECDB),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/streamline/add_2.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const Gap(15),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '장소 등록',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF463C33),
                            ),
                          ),
                          Text(
                            '주소를 등록하려면 클릭해주세요.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF989898),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(8),
            Container(
              height: 8,
              color: const Color(0xFFF8F5F0),
            ),
            // 장소 리스트
            Expanded(
              child: ListView.separated(
                itemCount: places.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF2F2F2),
                ),
                itemBuilder: (context, index) {
                  final place = places[index];
                  return Container(
                    padding: const EdgeInsets.fromLTRB(25, 20, 10, 20),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5ECDB),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/streamline/${place.icon}.svg',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        const Gap(15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF463C33),
                                ),
                              ),
                              const Gap(4),
                              Text(
                                place.address,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: place.isEmpty
                                      ? const Color(0xFF989898)
                                      : const Color(0xFF6E6E6E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(15),
                        if (!place.isEmpty) ...[
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(
                              CupertinoIcons.pencil,
                              size: 25,
                              color: Color(0xFF989898),
                            ),
                            onPressed: () {
                              // 수정 로직
                            },
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(
                              CupertinoIcons.xmark,
                              size: 25,
                              color: Color(0xFF989898),
                            ),
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) => CupertinoAlertDialog(
                                  title: const Text('장소 삭제'),
                                  content: Text('${place.name}을(를) 삭제하시겠습니까?'),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      child: const Text('취소'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        ref
                                            .read(placesProvider.notifier)
                                            .removePlace(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('삭제'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}