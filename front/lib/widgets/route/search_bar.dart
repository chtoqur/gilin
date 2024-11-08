import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final String hintText;
  final bool readOnly;
  final bool isRouteScreen;

  const CustomSearchBar({
    Key? key,
    this.controller,
    this.onTap,
    this.onSubmitted,
    this.hintText = '장소를 검색해보세요',
    this.readOnly = true,
    this.isRouteScreen = false, // true: 검색 아이콘, false: 뒤로 가기 버튼
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
          children: [
            const SizedBox(width: 16),
            // 동적으로 아이콘 변경
            GestureDetector(
              onTap: isRouteScreen ? null : () => Navigator.pop(context),
              child: Icon(
                isRouteScreen ? Icons.search : Icons.arrow_back,
                color: const Color(0xFF463C33),
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
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                style: const TextStyle(
                  color: Color(0xFF463C33),
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
