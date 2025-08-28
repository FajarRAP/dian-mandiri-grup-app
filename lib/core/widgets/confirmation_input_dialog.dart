import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../helpers/validators.dart';
import 'primary_button.dart';

class ConfirmationInputDialog extends StatefulWidget {
  const ConfirmationInputDialog({
    super.key,
    this.onAction,
    required this.actionText,
    required this.body,
    this.decoration,
    this.keyboardType,
    required this.title,
  });

  final void Function(String value)? onAction;
  final String actionText;
  final String body;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String title;

  @override
  State<ConfirmationInputDialog> createState() =>
      _ConfirmationInputDialogState();
}

class _ConfirmationInputDialogState extends State<ConfirmationInputDialog> {
  late final TextEditingController _controller;
  late final GlobalKey<FormState> _formKey;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusScope.of(context, createDependency: false);
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      contentPadding: EdgeInsets.all(24),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.body,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              onTapOutside: (_) => _focusNode.unfocus(),
              controller: _controller,
              decoration: widget.decoration,
              keyboardType: widget.keyboardType,
              validator: inputValidator,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: widget.onAction == null
                    ? null
                    : () {
                        if (!_formKey.currentState!.validate()) return;

                        widget.onAction!(_controller.text);
                      },
                child: Text(widget.actionText),
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
      ),
    );
  }
}
