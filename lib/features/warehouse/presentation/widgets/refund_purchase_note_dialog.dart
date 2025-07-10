import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/validators.dart';

class RefundPurchaseNoteDialog extends StatefulWidget {
  const RefundPurchaseNoteDialog({
    super.key,
    required this.onRefund,
  });

  final void Function(int refundAmount) onRefund;

  @override
  State<RefundPurchaseNoteDialog> createState() =>
      _RefundPurchaseNoteDialogState();
}

class _RefundPurchaseNoteDialogState extends State<RefundPurchaseNoteDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _refundController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _refundController = TextEditingController();
  }

  @override
  void dispose() {
    _refundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Refund'),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Masukkan nominal refund'),
            const SizedBox(height: 4),
            TextFormField(
              controller: _refundController,
              decoration: const InputDecoration(
                hintText: 'Nominal Refund',
              ),
              keyboardType: TextInputType.number,
              validator: nullValidator,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: context.pop,
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            widget.onRefund(int.parse(_refundController.text));
          },
          child: const Text('Ya'),
        ),
      ],
    );
  }
}
