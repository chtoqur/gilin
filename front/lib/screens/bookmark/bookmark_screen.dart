import 'package:flutter/material.dart';

enum SheetHeight { min, mid, max }

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  SheetHeight currentHeight = SheetHeight.mid;
  final double minHeight = 0.1;
  final double midHeight = 0.45;
  final double maxHeight = 0.8;
  final ScrollController scrollController = ScrollController();
  double dragStartY = 0;
  double currentDragHeight = 0;
  // 드래그 중인지 여부
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    // 초기 높이 설정
    currentDragHeight = midHeight;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        const Center(
          child: Text('Bookmark Home Screen'),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onVerticalDragStart: (details) {
              dragStartY = details.globalPosition.dy;
              isDragging = true;
              currentDragHeight = currentHeight == SheetHeight.min
                  ? minHeight
                  : currentHeight == SheetHeight.mid
                  ? midHeight
                  : maxHeight;
            },
            onVerticalDragUpdate: (details) {
              if (scrollController.offset <= 0) {
                final dragDistance = details.globalPosition.dy - dragStartY;
                // 부호를 반대로 변경 (음수를 양수로, 양수를 음수로)
                final heightDelta = -dragDistance / screenHeight;

                setState(() {
                  // 드래그 중인 높이 계산
                  currentDragHeight = (currentHeight == SheetHeight.min
                      ? minHeight
                      : currentHeight == SheetHeight.mid
                      ? midHeight
                      : maxHeight) + heightDelta;

                  // 높이 제한
                  currentDragHeight = currentDragHeight.clamp(minHeight, maxHeight);
                });
              }
            },
            onVerticalDragEnd: (details) {
              isDragging = false;

              // 현재 높이와 가장 가까운 상태로 설정
              setState(() {
                if ((maxHeight - currentDragHeight).abs() < (midHeight - currentDragHeight).abs() &&
                    (maxHeight - currentDragHeight).abs() < (minHeight - currentDragHeight).abs()) {
                  currentHeight = SheetHeight.max;
                } else if ((midHeight - currentDragHeight).abs() < (minHeight - currentDragHeight).abs()) {
                  currentHeight = SheetHeight.mid;
                } else {
                  currentHeight = SheetHeight.min;
                }
              });
            },
            child: AnimatedContainer(
              duration: isDragging
                  ? Duration.zero  // 드래그 중에는 애니메이션 없음
                  : const Duration(milliseconds: 300),  // 드래그 끝났을 때 애니메이션
              curve: Curves.easeInOut,
              height: screenHeight * (isDragging
                  ? currentDragHeight  // 드래그 중일 때는 실시간 높이
                  : (currentHeight == SheetHeight.min  // 드래그가 끝났을 때는 정해진 높이
                  ? minHeight
                  : currentHeight == SheetHeight.mid
                  ? midHeight
                  : maxHeight)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: currentHeight == SheetHeight.min
                          ? const NeverScrollableScrollPhysics()
                          : const ClampingScrollPhysics(),
                      child: const Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '수현님, 어디가시나요?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                IconWithLabel(
                                  icon: Icons.home,
                                  label: '집',
                                ),
                                IconWithLabel(
                                  icon: Icons.school,
                                  label: '학사/학교',
                                ),
                                IconWithLabel(
                                  icon: Icons.add,
                                  label: '추가하기',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text('전체 목록 4'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// IconWithLabel 클래스 추가
class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithLabel({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}