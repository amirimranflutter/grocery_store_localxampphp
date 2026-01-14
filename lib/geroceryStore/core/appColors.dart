import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryRed = Color(0xFFC73E3E);
  static const Color primaryRedDark = Color(0xFFA52D2D);
  static const Color primaryRedLight = Color(0xFFE85555);

  // Accent Colors
  static const Color accentOrange = Color(0xFFFF8C00);
  static const Color accentYellow = Color(0xFFFFD700);

  // Background Colors
  static const Color bgLight = Color(0xFFFFF5F5);
  static const Color bgGray = Color(0xFFF8F9FA);
  static const Color bgWhite = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textGray = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFF999999);

  // Border Colors
  static const Color borderColor = Color(0xFFE5E5E5);

  // Status Colors
  static const Color success = Color(0xFF52B788);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF1C40F);

  // Gradients
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, Color(0xFFFF6B35)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgWhite, bgLight],
  );

  // Legacy support
  static const Color primary = primaryRed;
  static const Color secondary = accentOrange;
  static const Color background = bgGray;
  static const Color surface = bgWhite;
  static const Color textPrimary = textDark;
  static const Color textSecondary = textGray;
}
