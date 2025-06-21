import 'package:flutter/material.dart';

import '../themes/colors.dart';

class DropdownModalItem extends StatelessWidget {
  const DropdownModalItem({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MaterialColors.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      width: double.infinity,
      child: child,
    );
  }
}
