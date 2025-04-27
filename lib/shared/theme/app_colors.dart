import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFF7A814);
  static const Color secondary = Color(0xFFE8246F);
  static const Color detail = Color(0xFFEF5E61);

  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.secondary,
    ]
  );
}