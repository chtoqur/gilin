import 'package:flutter/material.dart';

class Destination {
  final IconData icon;
  final String name;
  final String address;
  final String arrivalTime;

  const Destination({
    required this.icon,
    required this.name,
    required this.address,
    required this.arrivalTime,
  });
}