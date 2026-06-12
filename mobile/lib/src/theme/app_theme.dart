import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF18B7AE),
    secondary: const Color(0xFFFFC247),
    tertiary: const Color(0xFF8B63E8),
    surface: const Color(0xFFFFFBF2),
  );

  const textColor = Color(0xFF164C55);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFFFFFBF2),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        color: textColor,
        fontSize: 38,
        fontWeight: FontWeight.w900,
        height: 1.02,
      ),
      headlineMedium: TextStyle(
        color: textColor,
        fontSize: 34,
        fontWeight: FontWeight.w900,
        height: 1.05,
      ),
      headlineSmall: TextStyle(
        color: textColor,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        height: 1.08,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 19,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF426A70),
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF426A70),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      labelLarge: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      labelMedium: TextStyle(
        color: Color(0xFF426A70),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      labelSmall: TextStyle(
        color: Color(0xFF6B878A),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFBF2),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 8,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFFF6F6B),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFFD6EDE8), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFFD6EDE8), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Color(0xFF18B7AE), width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFCFF7EF),
      labelStyle: const TextStyle(
        color: textColor,
        fontWeight: FontWeight.w900,
      ),
      secondaryLabelStyle: const TextStyle(
        color: textColor,
        fontWeight: FontWeight.w900,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFD6EDE8), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
  );
}
