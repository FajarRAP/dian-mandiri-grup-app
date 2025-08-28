import 'package:flutter/material.dart';

import '../themes/colors.dart';

class LightButton extends StatelessWidget {
  const LightButton({
    super.key,
    this.onPressed,
    this.height,
    required this.icon,
    required this.label,
  });

  final void Function()? onPressed;
  final double? height;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: ElevatedButton.styleFrom(
        backgroundColor: MaterialColors.surfaceContainerLowest,
        foregroundColor: MaterialColors.onSurface,
        fixedSize: height == null ? null : Size.fromHeight(height!),
      ),
    );
  }
}
