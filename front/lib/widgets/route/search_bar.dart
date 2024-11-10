import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final String hintText;
  final bool readOnly;
  final bool isRouteScreen;
  final bool showSearchButton;

  const CustomSearchBar({
    Key? key,
    this.controller,
    this.onTap,
    this.onSubmitted,
    this.onChanged,
    this.hintText = '장소를 검색해보세요',
    this.readOnly = true,
    this.isRouteScreen = false,
    this.showSearchButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            IconButton(  // GestureDetector 대신 IconButton 사용
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF463C33),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: readOnly,
                onTap: onTap,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Color(0xFF463C33),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (showSearchButton) ...[  // 검색 버튼을 조건부로 표시
              GestureDetector(
                onTap: () {
                  if (onSubmitted != null && controller != null) {
                    onSubmitted!(controller!.text);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '검색',
                    style: TextStyle(
                      color: Color(0xFF463C33),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}
