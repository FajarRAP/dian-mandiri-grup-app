import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

class AppTextTheme {
  const AppTextTheme._();

  static final light = TextTheme(
    displayLarge: TextStyle(
      color: AppColorScheme.light.onSurface,
      fontSize: 57,
    ),
    displayMedium: TextStyle(
      color: AppColorScheme.light.onSurface,
      fontSize: 45,
    ),
    displaySmall: TextStyle(
      color: AppColorScheme.light.onSurface,
      fontSize: 36,
    ),
    headlineLarge: TextStyle(
      color: AppColorScheme.light.onSurface,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      color: AppColorScheme.light.onSurface,
      fontSize: 28,
    ),
    headlineSmall: TextStyle(
      color: AppColorScheme.light.onSurface,
      fontSize: 24,
    ),
    titleLarge: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 22),
    titleMedium: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 16),
    titleSmall: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 14),
    bodyLarge: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 16),
    bodyMedium: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 14),
    bodySmall: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 12),
    labelLarge: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 14),
    labelMedium: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 12),
    labelSmall: TextStyle(color: AppColorScheme.light.onSurface, fontSize: 11),
  );

  static final dark = TextTheme(
    displayLarge: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 57),
    displayMedium: TextStyle(
      color: AppColorScheme.dark.onSurface,
      fontSize: 45,
    ),
    displaySmall: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 36),
    headlineLarge: TextStyle(
      color: AppColorScheme.dark.onSurface,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      color: AppColorScheme.dark.onSurface,
      fontSize: 28,
    ),
    headlineSmall: TextStyle(
      color: AppColorScheme.dark.onSurface,
      fontSize: 24,
    ),
    titleLarge: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 22),
    titleMedium: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 16),
    titleSmall: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 14),
    bodyLarge: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 16),
    bodyMedium: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 14),
    bodySmall: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 12),
    labelLarge: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 14),
    labelMedium: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 12),
    labelSmall: TextStyle(color: AppColorScheme.dark.onSurface, fontSize: 11),
  );
}
