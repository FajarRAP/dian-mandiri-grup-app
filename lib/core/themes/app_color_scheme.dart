import 'package:flutter/material.dart';

class AppColorScheme {
  const AppColorScheme._();

  static final light = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4E71FF),
    brightness: .light,
    dynamicSchemeVariant: .fidelity,
  );

  static final dark = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4E71FF),
    dynamicSchemeVariant: .fidelity,
    brightness: .dark,
  );
}
