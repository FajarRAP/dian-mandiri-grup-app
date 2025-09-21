import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/widgets/confirmation_input_dialog.dart';
import '../cubit/shipment_cubit.dart';

class CheckReceiptStatusFromScannerDialog extends StatelessWidget {
  const CheckReceiptStatusFromScannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();

    return BlocConsumer<ShipmentCubit, ShipmentState>(
      buildWhen: (previous, current) => current is FetchReceiptStatus,
      listenWhen: (previous, current) => current is FetchReceiptStatus,
      listener: (context, state) {
        if (state is FetchReceiptStatusLoaded) {
          context.pop();
        }
      },
      builder: (context, state) {
        final onAction = switch (state) {
          FetchReceiptStatusLoading() => null,
          _ => (String value) async => await shipmentCubit
              .fetchShipmentByReceiptNumber(receiptNumber: value),
        };

        return ConfirmationInputDialog(
          onAction: onAction,
          actionText: 'Cari',
          body: 'Silakan scan nomor resi menggunakan scanner',
          textFormFieldConfig: TextFormFieldConfig(
            onFieldSubmitted: (value) => shipmentCubit
                .fetchShipmentByReceiptNumber(receiptNumber: value),
            autoFocus: true,
            decoration: const InputDecoration(
              labelText: 'Hasil Scan',
            ),
            textInputAction: TextInputAction.send,
          ),
          title: 'Cari Resi',
        );
      },
    );
  }
}
