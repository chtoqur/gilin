// widgets/location_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LocationItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const LocationItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/icons/pin_2.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
