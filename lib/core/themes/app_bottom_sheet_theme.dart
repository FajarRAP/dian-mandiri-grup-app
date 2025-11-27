import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

class AppBottomSheetTheme {
  const AppBottomSheetTheme._();

  static BottomSheetThemeData _buildTheme({required ColorScheme colorScheme}) {
    return BottomSheetThemeData(
      constraints: const BoxConstraints(maxHeight: 550),
      dragHandleColor: colorScheme.onSurfaceVariant,
      dragHandleSize: const Size(48, 4),
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(28)),
      ),
      showDragHandle: true,
    );
  }

  static final light = _buildTheme(colorScheme: AppColorScheme.light);

  static final dark = _buildTheme(colorScheme: AppColorScheme.dark);
}
