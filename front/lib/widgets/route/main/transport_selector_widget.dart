import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/route/route_state.dart';

class TransportSelectorWidget extends ConsumerStatefulWidget {
  const TransportSelectorWidget({super.key});

  @override
  ConsumerState<TransportSelectorWidget> createState() => _TransportModeSelectorState();
}

class _TransportModeSelectorState extends ConsumerState<TransportSelectorWidget> {
  final Map<String, IconData> transportIcons = {
    '지하철': Icons.subway,
    '버스': Icons.directions_bus,
    '택시': Icons.local_taxi,
    '자전거': Icons.directions_bike,
    '도보': Icons.directions_walk,
  };

  @override
  Widget build(BuildContext context) {
    var routeState = ref.watch(routeProvider);
    var routeNotifier = ref.read(routeProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: transportIcons.entries.map((entry) {
          var mode = entry.key;
          var icon = entry.value;
          var isSelected = routeState.selectedTransports.contains(mode);

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  List<String> newTransports = List.from(routeState.selectedTransports);
                  if (isSelected) {
                    newTransports.remove(mode);
                  } else {
                    newTransports.add(mode);
                  }
                  routeNotifier.updateTransports(newTransports);
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
                    icon,
                    color: isSelected
                        ? const Color(0xFF463C33)
                        : const Color(0xFFCBC5B6),
                    size: 34,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                mode,
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