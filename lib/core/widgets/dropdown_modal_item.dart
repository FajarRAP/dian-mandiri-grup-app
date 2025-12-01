import 'package:flutter/material.dart';

import '../utils/extensions.dart';

class DropdownModalItem extends StatelessWidget {
  const DropdownModalItem({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: .all(color: context.colorScheme.outline),
        borderRadius: .circular(12),
      ),
      margin: const .symmetric(horizontal: 16),
      padding: const .symmetric(horizontal: 16, vertical: 20),
      width: .infinity,
      child: child,
    );
  }
}
