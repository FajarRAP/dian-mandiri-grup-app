import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    this.icon,
    this.height,
    required this.child,
  });

  final void Function()? onPressed;
  final Widget? icon;
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: child,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
        fixedSize: height == null ? null : .fromHeight(height!),
      ),
    );
  }
}
