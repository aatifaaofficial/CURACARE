import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF16324F);
  static const blue = Color(0xFF3279D7);
  static const teal = Color(0xFF2AAE9B);
  static const purple = Color(0xFF8067D8);
  static const coral = Color(0xFFE86C67);
  static const background = Color(0xFFF6F8FC);
  static const ink = Color(0xFF213047);
  static const muted = Color(0xFF7D8A9F);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
    ).copyWith(
      primary: blue,
      secondary: teal,
      surface: Colors.white,
      onSurface: ink,
      error: coral,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'sans',
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ink),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ink),
        bodyLarge: TextStyle(fontSize: 15, color: ink),
        bodyMedium: TextStyle(fontSize: 13, color: muted),
        labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: blue.withValues(alpha: 0.13),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}
