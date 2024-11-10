import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RouteSelectorWidget extends StatefulWidget {
  const RouteSelectorWidget({super.key});

  @override
  State<RouteSelectorWidget> createState() => _RoutePickerWidgetState();
}

class _RoutePickerWidgetState extends State<RouteSelectorWidget> {
  String startPoint = "멀티캠퍼스 역삼";
  String endPoint = "북촉 한옥마을";

  void swapLocations() {
    setState(() {
      var temp = startPoint;
      startPoint = endPoint;
      endPoint = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(3, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 150, // 적절한 너비 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      '출발',
                      style: TextStyle(
                          color: Color(0xFFD7C3A8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                GestureDetector(
                  onTap: () {
                    context.push('/search');
                  },
                  child: Text(
                    startPoint,
                    style: const TextStyle(
                      color: Color(0xFF463C33),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(5),
                const Divider(
                  color: Color(0xFFD7C3A8),
                  thickness: 1,
                  indent: 0,
                  endIndent: 10,
                ),
                const Gap(5),
                const Row(
                  children: [
                    Text(
                      '도착',
                      style: TextStyle(
                          color: Color(0xFFD7C3A8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                GestureDetector(
                  onTap: () {
                    context.push('/search');
                  },
                  child: Text(
                    endPoint,
                    style: const TextStyle(
                      color: Color(0xFF463C33),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 위치 교환 버튼
          GestureDetector(
            onTap: swapLocations,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE1D4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.swap_vert,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}