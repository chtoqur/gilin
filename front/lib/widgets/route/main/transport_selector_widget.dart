import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/route/route_state.dart';

class TransportSelectorWidget extends ConsumerStatefulWidget {
  const TransportSelectorWidget({super.key});

  @override
  ConsumerState<TransportSelectorWidget> createState() => _TransportModeSelectorState();
}

class _TransportModeSelectorState extends ConsumerState<TransportSelectorWidget> {

  final Map<TransportMode, IconData> transportIcons = {
    TransportMode.subway: Icons.subway,
    TransportMode.bus: Icons.directions_bus,
    TransportMode.taxi: Icons.local_taxi,
    TransportMode.bicycle: Icons.directions_bike,
    TransportMode.walk: Icons.directions_walk,
  };

  // TransportMode에 대한 한글 이름 매핑
  final Map<TransportMode, String> transportNames = {
    TransportMode.subway: '지하철',
    TransportMode.bus: '버스',
    TransportMode.taxi: '택시',
    TransportMode.bicycle: '자전거',
    TransportMode.walk: '도보',
  };

  @override
  Widget build(BuildContext context) {

    var selectedMode = ref.watch(routeProvider).selectedTransportModes;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // 투명도 15%
            offset: const Offset(3, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: TransportMode.values.map((mode) {
          var isSelected = selectedMode.contains(mode);


          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(routeProvider.notifier).toggleTransportMode(mode);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF8EAAB)
                        : const Color(0xFFF5F1E0),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                      ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: -1,
                        ),
                      ]
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    transportIcons[mode],
                    color: isSelected
                        ? const Color(0xFF463C33)
                        : const Color(0xFFCBC5B6),
                    size: 34,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transportNames[mode]!,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF463C33)
                      : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}