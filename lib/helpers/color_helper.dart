import 'package:flutter/material.dart';

class ColorHelper {
  static Color getColorForIndex(int index) {
    final colors = [
      const Color(0xFFE8F4F8),
      const Color(0xFFFFF4E8),
      const Color(0xFFE8F0FF),
      const Color(0xFFFFE8E8),
      const Color(0xFFF0E8FF),
    ];

    return colors[index % colors.length];
  }
}