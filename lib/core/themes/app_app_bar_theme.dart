import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_text_theme.dart';

class AppAppBarTheme {
  const AppAppBarTheme._();

  static final light = AppBarTheme(
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColorScheme.light.primary),
    titleTextStyle: AppTextTheme.light.titleLarge?.copyWith(
      color: AppColorScheme.light.primary,
      fontWeight: FontWeight.w500,
    ),
  );

  static final dark = AppBarTheme(
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColorScheme.dark.primary),
    titleTextStyle: AppTextTheme.dark.titleLarge?.copyWith(
      color: AppColorScheme.dark.primary,
      fontWeight: FontWeight.w500,
    ),
  );
}
