import 'package:flutter/material.dart';

import 'app_app_bar_theme.dart';
import 'app_bottom_sheet_theme.dart';
import 'app_button_theme.dart';
import 'app_color_scheme.dart';
import 'app_floating_action_button_theme.dart';
import 'app_input_decoration_theme.dart';
import 'app_progress_indicator_theme.dart';
import 'app_text_theme.dart';

final theme = ThemeData(
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
