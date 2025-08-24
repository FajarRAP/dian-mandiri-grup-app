import 'package:flutter/material.dart';

import '../themes/colors.dart';

class DangerTextButton extends StatelessWidget {
  const DangerTextButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: MaterialColors.error,
      ),
      child: child,
    );
  }
}
