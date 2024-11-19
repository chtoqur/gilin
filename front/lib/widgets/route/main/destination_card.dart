import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:gilin/models/route/destination.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF8F5F0),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xffFDA868), width: 3)
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffF8F5F0),
                    border:
                        Border.all(color: const Color(0xff463C33), width: 1),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      destination.iconPath,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const Gap(10),
                Text(
                  destination.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Gap(5),
            Text(
              destination.address,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            const Gap(2),
            Text(
              destination.arrivalTime,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
