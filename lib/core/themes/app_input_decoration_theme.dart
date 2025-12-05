import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

class AppInputDecorationTheme {
  const AppInputDecorationTheme._();

  static InputDecorationTheme _buildTheme({
    required ColorScheme colorScheme,
    required Color fillColor,
  }) {
    final borderRadius = BorderRadius.circular(10);

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
      prefixIconColor: colorScheme.onSurfaceVariant,
      suffixIconColor: colorScheme.onSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
    );
  }

  static final light = _buildTheme(
    colorScheme: AppColorScheme.light,
    fillColor: AppColorScheme.light.surfaceContainerLowest,
  );

  static final dark = _buildTheme(
    colorScheme: AppColorScheme.dark,
    fillColor: AppColorScheme.dark.surfaceContainer,
  );
}
