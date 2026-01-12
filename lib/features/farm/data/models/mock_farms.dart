import 'dart:ui';
import 'package:flutter/material.dart';

class FarmData {
  final String name;
  final String status; // 'good', 'poor', 'bad'
  final Color statusColor;

  FarmData({
    required this.name,
    required this.status,
    required this.statusColor,
  });
}

final List<FarmData> mockFarms = [
  FarmData(
    name: 'Palakkad',
    status: 'Good',
    statusColor: const Color(0xFFD4E157),
  ), // Lime Green
  FarmData(
    name: 'Pollachi',
    status: 'Medium',
    statusColor: const Color(0xFFFFA726),
  ), // Orange
  FarmData(
    name: 'Coimbatore',
    status: 'Bad',
    statusColor: const Color(0xFFEF5350),
  ), // Red
];
