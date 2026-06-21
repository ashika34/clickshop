import 'package:flutter/material.dart';

abstract final class AppColors {
  static const darkGreen = Color(0xFF159447);
  static const lightGreen = Color(0xFF59C43A);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.darkGreen)
        .copyWith(
          primary: AppColors.darkGreen,
          secondary: AppColors.lightGreen,
          surface: Colors.white,
          onSurface: const Color(0xFF17191C),
          onSurfaceVariant: const Color(0xFF666B72),
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
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

  static ThemeData get dark {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.darkGreen,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.lightGreen,
          secondary: AppColors.darkGreen,
          surface: const Color(0xFF1C1F1D),
          onSurface: const Color(0xFFF3F5F3),
        );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF111312),
      canvasColor: const Color(0xFF1C1F1D),
      cardColor: const Color(0xFF1C1F1D),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1C1F1D),
        indicatorColor: AppColors.lightGreen.withValues(alpha: 0.22),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1F1D),
        foregroundColor: Color(0xFFF3F5F3),
        surfaceTintColor: Colors.transparent,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1C1F1D)),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: Colors.white,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lightGreen,
      ),
      useMaterial3: true,
    );
  }
}
