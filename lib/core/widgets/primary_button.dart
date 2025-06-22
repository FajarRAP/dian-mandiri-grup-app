import 'package:flutter/material.dart';

import '../themes/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.onPressed,
  });

  final Widget child;
  final double? height;
  final double? width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primaryNormal,
        foregroundColor: MaterialColors.onPrimary,
        fixedSize: Size(
          width ?? MediaQuery.sizeOf(context).width,
          height ?? 48,
        ),
      ),
      child: child,
    );
  }
}
