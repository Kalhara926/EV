// lib/utils/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // --- Primary & Accent Colors ---
  static const Color primaryColor = Color(0xFF007BFF); // A vibrant, modern blue
  static const Color primaryColorDark = Color(0xFF0056b3);
  static const Color accentColor =
      Color(0xFF00C49A); // A fresh, electric green/teal

  // --- Background Colors ---
  static const Color backgroundColor =
      Color(0xFFF4F6F8); // Light grey for background
  static const Color surfaceColor = Colors.white; // For cards, dialogs etc.

  // --- Text Colors ---
  static const Color textPrimary =
      Color(0xFF212529); // Nearly black for main text
  static const Color textSecondary = Color(0xFF6c757d); // Grey for subtext
  static const Color textOnPrimary =
      Colors.white; // Text on top of primary color

  // --- State Colors ---
  static const Color success = Color(0xFF28a745);
  static const Color error = Color(0xFFdc3545);
  static const Color warning = Color(0xFFffc107);
}
