import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../cubit/ship_cubit.dart';

class CheckReceiptFromScannerAlertDialog extends StatefulWidget {
  const CheckReceiptFromScannerAlertDialog({super.key});

  @override
  State<CheckReceiptFromScannerAlertDialog> createState() =>
      _CheckReceiptFromScannerAlertDialogState();
}

class _CheckReceiptFromScannerAlertDialogState
    extends State<CheckReceiptFromScannerAlertDialog> {
  final _receiptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _receiptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Silakan Scan',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Resi:',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            TextFormField(
              autofocus: true,
              controller: _receiptController,
              decoration: const InputDecoration(
                hintText: 'Hasil Scan',
              ),
              focusNode: FocusNode(),
              validator: inputValidator,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            await context
                .read<ShipCubit>()
                .getReceiptStatus(_receiptController.text.trim());
          },
          child: BlocConsumer<ShipCubit, ShipState>(
            listener: (context, state) {
              if (state is CheckReceiptStatusError) {
                flushbar(context, state.message);
              }
              if (state is CheckReceiptStatusLoaded) {
                context.pop();
              }
            },
            builder: (context, state) {
              if (state is CheckReceiptStatusLoading) {
                return const CircularProgressIndicator();
              }
              return const Text(
                'Cari',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
