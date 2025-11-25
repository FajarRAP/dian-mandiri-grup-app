import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'colors.dart';

const fontFamily = 'Inter18pt';

final theme = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    iconTheme: IconThemeData(color: CustomColors.primaryNormal),
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      color: CustomColors.primaryNormal,
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    constraints: BoxConstraints(
      maxHeight: 550,
    ),
    dragHandleColor: Color(0xFFE0E0E0),
    dragHandleSize: Size(48, 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    showDragHandle: true,
  ),
  colorScheme: colorScheme,
  fontFamily: fontFamily,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: CustomColors.primaryNormal,
    foregroundColor: MaterialColors.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  indicatorColor: CustomColors.primaryNormal,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: MaterialColors.outlineVariant),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: MaterialColors.error),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: CustomColors.primaryNormalActive,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: MaterialColors.error,
        width: 2,
      ),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
    hintStyle: const TextStyle(
      color: MaterialColors.onSurfaceVariant,
      fontSize: 16,
    ),
    prefixIconColor: MaterialColors.outlineVariant,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: CustomColors.primaryNormal,
    circularTrackColor: MaterialColors.outlineVariant,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
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
