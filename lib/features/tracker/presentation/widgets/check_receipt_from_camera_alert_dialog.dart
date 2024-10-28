import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/snackbar.dart';
import '../cubit/ship_cubit.dart';

class CheckReceiptFromCameraAlertDialog extends StatelessWidget {
  const CheckReceiptFromCameraAlertDialog({
    super.key,
    required this.receiptNumber,
  });

  final String receiptNumber;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Berhasil Scan!',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Resi:',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            receiptNumber,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async =>
              await context.read<ShipCubit>().getReceiptStatus(receiptNumber),
          child: BlocConsumer<ShipCubit, ShipState>(
            listener: (context, state) {
              if (state is CheckReceiptStatusLoaded) {
                context.pop();
              }
              if (state is CheckReceiptStatusError) {
                flushbar(context, state.message);
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
