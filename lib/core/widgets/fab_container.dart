import 'package:flutter/material.dart';

import '../themes/colors.dart';

class FABContainer extends StatelessWidget {
  const FABContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: MaterialColors.outlineVariant,
            width: 1,
          ),
        ),
        color: MaterialColors.surfaceContainerLowest,
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
