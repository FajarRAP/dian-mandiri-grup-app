import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class FABContainer extends StatelessWidget {
  const FABContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.colorScheme.outlineVariant),
        ),
        color: context.colorScheme.surfaceContainerLowest,
      ),
      width: .infinity,
      padding: const .all(16),
      child: child,
    );
  }
}
