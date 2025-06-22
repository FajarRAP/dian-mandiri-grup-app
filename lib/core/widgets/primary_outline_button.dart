import 'package:flutter/material.dart';

import '../themes/colors.dart';

class PrimaryOutlineButton extends StatelessWidget {
  const PrimaryOutlineButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    required this.child,
  });

  final void Function()? onPressed;
  final double? height;
  final double? width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MaterialColors.onPrimary,
        elevation: 0,
        foregroundColor: CustomColors.primaryNormal,
        fixedSize: Size(
          width ?? MediaQuery.sizeOf(context).width,
          height ?? 48,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        side: BorderSide(
          color: CustomColors.primaryNormal,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      child: child,
    );
  }
}
