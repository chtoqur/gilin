import 'package:flutter/material.dart';
import '../../models/search/local_search_result.dart';
import 'search_result_item.dart';

class SearchBottomSheet extends StatefulWidget {
  final List<LocalSearchResult> searchResults;
  final Function(LocalSearchResult) onResultTap;

  const SearchBottomSheet({
    Key? key,
    required this.searchResults,
    required this.onResultTap,
  }) : super(key: key);

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
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
      height: height,
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
                  physics: (currentHeight == SheetHeight.min ||
                          currentHeight == SheetHeight.mid)
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Column(
                    children: widget.searchResults
                        .map((result) => GestureDetector(
                              onTap: () => widget.onResultTap(result),
                              child: SearchResultItem(result: result),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

enum SheetHeight { min, mid, max }
