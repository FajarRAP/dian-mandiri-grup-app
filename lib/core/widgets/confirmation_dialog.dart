import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'primary_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.onAction,
    required this.actionText,
    required this.title,
    required this.body,
  });

  final void Function()? onAction;
  final String actionText;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      contentPadding: EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: context.pop,
              child: const Text('Batal'),
            ),
          ),
        ],
      ),
    );
  }
}
