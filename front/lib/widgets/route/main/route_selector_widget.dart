import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gilin/state/route/route_state.dart';

class RouteSelectorWidget extends ConsumerStatefulWidget {
  const RouteSelectorWidget({super.key});

  @override
  ConsumerState<RouteSelectorWidget> createState() => _RoutePickerWidgetState();
}


class _RoutePickerWidgetState extends ConsumerState<RouteSelectorWidget> {
  @override
  void initState() {
    super.initState();
      _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      ref.read(routeProvider.notifier).setLocation(
        "내 위치",
        position.longitude,
        position.latitude,

      );
    } catch (e) {
      print('위치 가져오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var routeState = ref.watch(routeProvider);

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
            width: MediaQuery.of(context).size.width - 150,
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                GestureDetector(
                  onTap: () {
                    ref.read(routeProvider.notifier).setInputMode(RouteInputMode.start);
                    context.push('/search');
                  },
                  child: Text(
                    routeState.startPoint.title.isEmpty ? "내 위치" : routeState.startPoint.title,
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Gap(5),
                GestureDetector(
                  onTap: () {
                    ref.read(routeProvider.notifier).setInputMode(RouteInputMode.end);
                    context.push('/search');
                  },
                  child: Text(
                    routeState.endPoint.title.isEmpty ? "목적지를 선택해주세요." : routeState.endPoint.title,
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
          GestureDetector(
            onTap: () => ref.read(routeProvider.notifier).swapLocations(),
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