import 'package:flutter/material.dart';

class Destination {
  final String iconPath;
  final String name;
  final String address;
  final String arrivalTime;

  const Destination({
    required this.iconPath,
    required this.name,
    required this.address,
    required this.arrivalTime,
  });
}