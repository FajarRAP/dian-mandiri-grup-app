import 'package:flutter/material.dart';

const fontFamily = 'Inter18pt';

final theme = ThemeData(
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  fontFamily: fontFamily,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[400],
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 57,
    ),
    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 45,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 36,
    ),
    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontSize: 28,
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
  ),
  useMaterial3: true,
);
