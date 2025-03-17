import 'package:flutter/material.dart';

class PrimaryIconButton extends StatelessWidget {
  const PrimaryIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.height,
    this.width,
    this.onPressed,
  });

  final Widget icon;
  final Widget label;
  final double? height;
  final double? width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        fixedSize: Size(
          width ?? MediaQuery.sizeOf(context).width,
          height ?? 48,
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: icon,
      label: label,
    );
  }
}
