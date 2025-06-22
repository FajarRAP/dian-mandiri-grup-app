import 'package:flutter/material.dart';

class LightIconButton extends StatelessWidget {
  const LightIconButton({
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
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
