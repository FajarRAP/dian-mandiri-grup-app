import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.onPressed, required this.icon});

  final void Function() onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: .antiAlias,
      color: context.colorScheme.inversePrimary,
      elevation: 4,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: context.colorScheme.onSurface,
      ),
    );
  }
}
