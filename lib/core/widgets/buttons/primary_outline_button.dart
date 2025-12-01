import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class PrimaryOutlineButton extends StatelessWidget {
  const PrimaryOutlineButton({
    super.key,
    this.onPressed,
    this.height,
    this.icon,
    required this.child,
  });

  final void Function()? onPressed;
  final double? height;
  final Widget? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.onPrimary,
        elevation: 0,
        foregroundColor: context.colorScheme.primary,
        fixedSize: height == null ? null : Size.fromHeight(height!),
        side: BorderSide(color: context.colorScheme.primary, width: 1.5),
      ),
      icon: icon,
      label: child,
    );
  }
}
