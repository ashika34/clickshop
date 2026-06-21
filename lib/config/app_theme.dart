import 'package:flutter/material.dart';

abstract final class AppColors {
  static const darkGreen = Color(0xFF159447);
  static const lightGreen = Color(0xFF59C43A);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.darkGreen,
    ).copyWith(primary: AppColors.darkGreen, secondary: AppColors.lightGreen);

    return ThemeData(
      colorScheme: colorScheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: Colors.white,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.darkGreen,
      ),
      useMaterial3: true,
    );
  }
}
