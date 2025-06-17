import 'package:flutter/material.dart';

import '../themes/colors.dart';

class DangerButton extends StatelessWidget {
  const DangerButton({
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
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: danger,
        foregroundColor: neutral,
        fixedSize: Size(
          width ?? MediaQuery.sizeOf(context).width,
          height ?? 48,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.4,
          letterSpacing: .25,
        ),
      ),
      child: child,
    );
  }
}
