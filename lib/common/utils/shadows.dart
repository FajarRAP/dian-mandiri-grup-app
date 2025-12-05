import 'package:flutter/material.dart';

import '../../core/themes/colors.dart';

final cardBoxShadow = <BoxShadow>[
  BoxShadow(
    color: MaterialColors.shadow.withValues(alpha: .05),
    spreadRadius: 1,
    blurRadius: 8,
    offset: const Offset(0, 4),
  ),
];
