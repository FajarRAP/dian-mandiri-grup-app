import 'package:flutter/material.dart';

import '../themes/colors.dart';

class PrimaryOutlineIconButton extends StatelessWidget {
  const PrimaryOutlineIconButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
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
        backgroundColor: MaterialColors.onPrimary,
        elevation: 0,
        foregroundColor: CustomColors.primaryNormal,
        fixedSize: Size(
          width ?? MediaQuery.sizeOf(context).width,
          height ?? 48,
        ),
        side: BorderSide(
          color: CustomColors.primaryNormal,
          width: 1.5,
        ),
      ),
      icon: icon,
      label: label,
    );
  }
}
