import 'package:flutter/material.dart';

class AppColors {
  static const background    = Color(0xFF0A0A0A);
  static const surface       = Color(0xFF1A1A1A);
  static const surfaceAlt    = Color(0xFF242424);
  static const red           = Color(0xFFD42A2A);
  static const redDark       = Color(0xFF8B1A1A);
  static const redLight      = Color(0xFFFF4444);
  static const redGlow       = Color(0x33D42A2A);
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF888888);
  static const textMuted     = Color(0xFF555555);
  static const divider       = Color(0xFF2A2A2A);
  static const success       = Color(0xFF2ECC71);
  static const warning       = Color(0xFFF39C12);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.red,
      surface: AppColors.surface,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? Colors.white : AppColors.textSecondary),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.red : AppColors.surfaceAlt),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.red,
      thumbColor: AppColors.red,
      inactiveTrackColor: AppColors.surfaceAlt,
      overlayColor: AppColors.redGlow,
    ),
  );
}
