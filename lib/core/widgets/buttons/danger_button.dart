import 'package:flutter/material.dart';

import '../../themes/colors.dart';

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
        backgroundColor: MaterialColors.error,
        foregroundColor: MaterialColors.onError,
        fixedSize: height == null ? null : Size.fromHeight(height!),
      ),
    );
  }
}
