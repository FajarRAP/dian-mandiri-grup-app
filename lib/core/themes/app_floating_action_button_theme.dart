import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

class AppFloatingActionButtonTheme {
  AppFloatingActionButtonTheme._();

  static FloatingActionButtonThemeData _buildTheme({
    required ColorScheme colorScheme,
  }) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );
  }

  static final light = _buildTheme(colorScheme: AppColorScheme.light);

  static final dark = _buildTheme(colorScheme: AppColorScheme.dark);
}
