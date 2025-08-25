import 'package:flutter/material.dart';

import '../themes/colors.dart';

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
        backgroundColor: CustomColors.primaryNormal,
        foregroundColor: MaterialColors.onPrimary,
        fixedSize: Size.fromHeight(height ?? 40),
      ),
    );
  }
}
