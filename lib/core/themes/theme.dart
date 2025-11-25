import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'colors.dart';
import 'app_text_theme.dart';

const fontFamily = 'Inter18pt';

final theme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColorScheme.light.primary),
    titleTextStyle: AppTextTheme.light.titleLarge?.copyWith(
      color: AppColorScheme.light.primary,
      fontWeight: FontWeight.w500,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    constraints: BoxConstraints(maxHeight: 550),
    dragHandleColor: Color(0xFFE0E0E0),
    dragHandleSize: Size(48, 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    showDragHandle: true,
  ),
  colorScheme: AppColorScheme.light,
  fontFamily: fontFamily,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: CustomColors.primaryNormal,
    foregroundColor: MaterialColors.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),
  indicatorColor: CustomColors.primaryNormal,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      borderSide: const BorderSide(color: MaterialColors.error, width: 2),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  ),
  textTheme: AppTextTheme.light,
  useMaterial3: true,
);
