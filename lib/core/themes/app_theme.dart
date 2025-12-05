import 'package:flutter/material.dart';

import 'app_app_bar_theme.dart';
import 'app_bottom_sheet_theme.dart';
import 'app_button_theme.dart';
import 'app_color_scheme.dart';
import 'app_floating_action_button_theme.dart';
import 'app_input_decoration_theme.dart';
import 'app_progress_indicator_theme.dart';
import 'app_text_theme.dart';

class AppTheme {
  const AppTheme._();

  static final light = ThemeData(
    appBarTheme: AppAppBarTheme.light,
    bottomSheetTheme: AppBottomSheetTheme.light,
    colorScheme: AppColorScheme.light,
    fontFamily: 'Inter18pt',
    floatingActionButtonTheme: AppFloatingActionButtonTheme.light,
    elevatedButtonTheme: AppButtonTheme.elevatedLight,
    inputDecorationTheme: AppInputDecorationTheme.light,
    progressIndicatorTheme: AppProgressIndicatorTheme.light,
    textButtonTheme: AppButtonTheme.textLight,
    textTheme: AppTextTheme.light,
    useMaterial3: true,
  );

  static final dark = ThemeData(
    appBarTheme: AppAppBarTheme.dark,
    bottomSheetTheme: AppBottomSheetTheme.dark,
    colorScheme: AppColorScheme.dark,
    fontFamily: 'Inter18pt',
    floatingActionButtonTheme: AppFloatingActionButtonTheme.dark,
    elevatedButtonTheme: AppButtonTheme.elevatedDark,
    inputDecorationTheme: AppInputDecorationTheme.dark,
    progressIndicatorTheme: AppProgressIndicatorTheme.dark,
    textButtonTheme: AppButtonTheme.textDark,
    textTheme: AppTextTheme.dark,
    useMaterial3: true,
  );
}
