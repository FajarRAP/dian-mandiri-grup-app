import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../utils/extensions.dart';
import 'buttons/primary_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.onAction,
    required this.actionText,
    required this.body,
    required this.title,
  });

  final void Function()? onAction;
  final String actionText;
  final String body;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return AlertDialog(
      contentPadding: const .all(24),
      content: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: <Widget>[
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(fontWeight: .w700),
            textAlign: .center,
          ),
          const Gap(8),
          Text(
            body,
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            textAlign: .center,
          ),
          const Gap(24),
          PrimaryButton(onPressed: onAction, child: Text(actionText)),
          TextButton(onPressed: context.pop, child: const Text('Batal')),
        ],
      ),
    );
  }
}
