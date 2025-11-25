import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class LightButton extends StatelessWidget {
  const LightButton({
    super.key,
    this.onPressed,
    this.height,
    this.icon,
    required this.label,
  });

  final void Function()? onPressed;
  final double? height;
  final Widget? icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.surfaceContainerLowest,
        foregroundColor: context.colorScheme.onSurface,
        fixedSize: height == null ? null : .fromHeight(height!),
      ),
    );
  }
}
