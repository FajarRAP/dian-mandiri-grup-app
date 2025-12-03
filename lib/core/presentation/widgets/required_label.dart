import 'package:flutter/material.dart';

import '../../utils/extensions.dart';

class RequiredLabel extends StatelessWidget {
  const RequiredLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: context.colorScheme.onSurfaceVariant,
          fontSize: 16,
        ),
        children: <InlineSpan>[
          TextSpan(
            text: ' *',
            style: TextStyle(color: context.colorScheme.error),
          ),
        ],
      ),
    );
  }
}
