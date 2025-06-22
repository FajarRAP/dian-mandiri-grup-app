import 'package:flutter/material.dart';
import 'package:ship_tracker/core/themes/colors.dart';

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    super.key,
    this.height,
    this.width,
    this.onPressed,
    required this.icon,
    required this.label,
  });

  final void Function()? onPressed;
  final double? height;
  final double? width;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primaryNormal,
        foregroundColor: MaterialColors.onPrimary,
        fixedSize: Size(
          width ?? MediaQuery.sizeOf(context).width,
          height ?? 48,
        ),
      ),
      icon: icon,
      label: label,
    );
  }
}
