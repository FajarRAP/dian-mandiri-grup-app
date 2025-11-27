import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

class AppProgressIndicatorTheme {
  const AppProgressIndicatorTheme._();

  static ProgressIndicatorThemeData _buildTheme({
    required ColorScheme colorScheme,
  }) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      circularTrackColor: colorScheme.outlineVariant,
    );
  }

  static final light = _buildTheme(colorScheme: AppColorScheme.light);
  static final dark = _buildTheme(colorScheme: AppColorScheme.dark);
}
