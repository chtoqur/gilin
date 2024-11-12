import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class Place {
  final String name;
  final String address;

  Place({required this.name, required this.address});
}

class PlaceCard extends StatelessWidget {
  final Place? place;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;

  const PlaceCard({
    super.key,
    this.place,
    this.onEdit,
    this.onDelete,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (place == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        child: DottedBorder(
          color: const Color(0xFF989898),
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          padding: EdgeInsets.zero,
          dashPattern: const [3, 2],
          child: Container(
            width: 145,
            height: 147,
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFF5ECDB),
                    shape: OvalBorder(),
                  ),
                  child: const Icon(Icons.add, size: 15),
                ),
                const SizedBox(height: 5),
                const Text(
                  '추가하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  '자주가는 경로를\n등록해보세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      child: Flexible(
        child: DottedBorder(
          color: const Color(0xFF979797),
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          padding: EdgeInsets.zero,
          dashPattern: const [3, 2],
          child: Container(
            child: SizedBox(
              width: 145,
              height: 147,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 0,
                      child: Row(
                        children: [
                          const Icon(Icons.home, size: 20),
                          const SizedBox(width: 9),
                          Flexible(
                            child: Text(
                              place!.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    Flexible(
                      flex: 0,
                      child: Text(
                        place!.address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: onEdit,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(53, 25),
                              backgroundColor: const Color(0xFFD7C3A8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              '편집',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: onDelete,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(53, 25),
                              backgroundColor: const Color(0xFFE3E3E3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}

// place_list.dart
class PlaceList extends StatelessWidget {
  final List<Place> places;
  final Function(Place) onEdit;
  final Function(Place) onDelete;
  final VoidCallback onAdd;

  const PlaceList({
    super.key,
    required this.places,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...places.map((place) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PlaceCard(
              place: place,
              onEdit: () => onEdit(place),
              onDelete: () => onDelete(place),
            ),
          )),
          // 추가하기 카드
          PlaceCard(
            onAdd: onAdd,
          ),
        ],
      ),
    );
  }
}