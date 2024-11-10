import 'package:flutter/material.dart';

class TransportSelectorWidget extends StatefulWidget {
  const TransportSelectorWidget({super.key});

  @override
  State<TransportSelectorWidget> createState() => _TransportModeSelectorState();
}

class _TransportModeSelectorState extends State<TransportSelectorWidget> {
  final Map<String, bool> transportModes = {
    '지하철': true,
    '버스': true,
    '택시': false,
    '자전거': false,
    '도보': true,
  };

  final Map<String, IconData> transportIcons = {
    '지하철': Icons.subway,
    '버스': Icons.directions_bus,
    '택시': Icons.local_taxi,
    '자전거': Icons.directions_bike,
    '도보': Icons.directions_walk,
  };

  @override
  Widget build(BuildContext context) {
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
        children: transportModes.keys.map((mode) {
          var isSelected = transportModes[mode]!;
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    transportModes[mode] = !transportModes[mode]!;
                  });
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