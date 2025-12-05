import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';

class DangerButton extends StatelessWidget {
  const DangerButton({
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
      icon: icon,
      label: child,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.error,
        foregroundColor: context.colorScheme.onError,
        fixedSize: height == null ? null : .fromHeight(height!),
      ),
    );
  }
}
