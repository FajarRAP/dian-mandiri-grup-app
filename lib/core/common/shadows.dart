import 'package:flutter/material.dart';

import '../themes/colors.dart';

final cardBoxShadow = <BoxShadow>[
  BoxShadow(
    color: MaterialColors.shadow.withValues(alpha: .09),
    offset: Offset(0, 2),
    blurRadius: 16,
    spreadRadius: 0,
  ),
];
