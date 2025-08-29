import 'package:flutter/material.dart';

import '../../themes/colors.dart';

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
        backgroundColor: MaterialColors.onPrimary,
        elevation: 0,
        foregroundColor: CustomColors.primaryNormal,
        fixedSize: height == null ? null : Size.fromHeight(height!),
        side: BorderSide(
          color: CustomColors.primaryNormal,
          width: 1.5,
        ),
      ),
      icon: icon,
      label: child,
    );
  }
}
