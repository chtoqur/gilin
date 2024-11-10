import 'package:flutter/material.dart';

class RouteBottomSheet extends StatefulWidget {
  final Widget child;

  const RouteBottomSheet({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<RouteBottomSheet> createState() => _RouteBottomSheetState();
}

class _RouteBottomSheetState extends State<RouteBottomSheet> {
  SheetHeight currentHeight = SheetHeight.mid;
  final double minHeight = 0.06;
  final double midHeight = 0.2;
  final double maxHeight = 0.7;

  final ScrollController scrollController = ScrollController();
  double dragStartY = 0;
  double currentDragHeight = 0;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    currentDragHeight = midHeight;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var height = screenHeight *
        (isDragging
            ? currentDragHeight.clamp(minHeight, maxHeight)
            : (currentHeight == SheetHeight.min
                ? minHeight
                : currentHeight == SheetHeight.mid
                    ? midHeight
                    : maxHeight));

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: height, // 명시적 높이 설정
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
            var dragDistance = details.globalPosition.dy - dragStartY;
            var heightDelta = -dragDistance / screenHeight;

            setState(() {
              currentDragHeight = (currentHeight == SheetHeight.min
                      ? minHeight
                      : currentHeight == SheetHeight.mid
                          ? midHeight
                          : maxHeight) +
                  heightDelta;
            });
          }
        },
        onVerticalDragEnd: (details) {
          isDragging = false;
          var currentSize = currentDragHeight.clamp(minHeight, maxHeight);

          setState(() {
            if (currentSize > (midHeight + maxHeight) / 2) {
              currentHeight = SheetHeight.max;
            } else if (currentSize > (minHeight + midHeight) / 2) {
              currentHeight = SheetHeight.mid;
            } else {
              currentHeight = SheetHeight.min;
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF8F5F0),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: (currentHeight == SheetHeight.min ||
                          currentHeight == SheetHeight.mid)
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
                    child: widget.child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SheetHeight { min, mid, max }
