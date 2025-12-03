import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../utils/extensions.dart';
import 'buttons/primary_button.dart';

class ConfirmationInputDialog extends StatefulWidget {
  const ConfirmationInputDialog({
    super.key,
    this.onConfirm,
    required this.fieldBuilder,
    required this.actionText,
    required this.body,
    required this.title,
  });

  final void Function(String value)? onConfirm;
  final Widget Function(BuildContext context, TextEditingController controller)
  fieldBuilder;
  final String actionText;
  final String body;
  final String title;

  @override
  State<ConfirmationInputDialog> createState() =>
      _ConfirmationInputDialogState();
}

class _ConfirmationInputDialogState extends State<ConfirmationInputDialog> {
  late final TextEditingController _controller;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return AlertDialog(
      contentPadding: const .all(24),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          children: <Widget>[
            Text(
              widget.title,
              style: textTheme.titleLarge?.copyWith(fontWeight: .w700),
            ),
            const Gap(8),
            Text(
              widget.body,
              style: textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: .center,
            ),
            const Gap(24),
            widget.fieldBuilder(context, _controller),
            const Gap(24),
            SizedBox(
              width: .infinity,
              child: PrimaryButton(
                onPressed: widget.onConfirm == null ? null : _onSubmit,
                child: Text(widget.actionText),
              ),
            ),
            SizedBox(
              width: .infinity,
              child: TextButton(
                onPressed: context.pop,
                child: const Text('Batal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onConfirm?.call(_controller.text);
  }
}
