import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.child,
    required this.icon,
    this.height,
    this.width,
    this.onPressed,
  });

  final Widget child;
  final IconData icon;
  final double? height;
  final double? width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        fixedSize: Size(
          width ?? MediaQuery.sizeOf(context).width,
          height ?? 48,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: child,
    );
  }
}
