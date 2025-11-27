import 'package:flutter/material.dart';

import 'app_text_theme.dart';

class AppButtonTheme {
  const AppButtonTheme._();

  static final _defaultShape = RoundedRectangleBorder(
    borderRadius: .circular(10),
  );
  static const _defaultPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  static final elevatedLight = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: _defaultPadding,
      shape: _defaultShape,
      textStyle: AppTextTheme.light.bodyLarge?.copyWith(fontWeight: .w500),
    ),
  );
  static final elevatedDark = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: _defaultPadding,
      shape: _defaultShape,
      textStyle: AppTextTheme.dark.bodyLarge?.copyWith(fontWeight: .w500),
    ),
  );

  static final textLight = TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: _defaultPadding,
      shape: _defaultShape,
      textStyle: AppTextTheme.light.bodyLarge?.copyWith(fontWeight: .w500),
    ),
  );

  static final textDark = TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: _defaultPadding,
      shape: _defaultShape,
      textStyle: AppTextTheme.dark.bodyLarge?.copyWith(fontWeight: .w500),
    ),
  );
}
