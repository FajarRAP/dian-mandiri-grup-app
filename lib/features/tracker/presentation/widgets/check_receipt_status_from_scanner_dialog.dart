import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/widgets/confirmation_input_dialog.dart';
import '../cubit/shipment_detail/shipment_detail_cubit.dart';

class CheckReceiptStatusFromScannerDialog extends StatelessWidget {
  const CheckReceiptStatusFromScannerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShipmentDetailCubit, ShipmentDetailState>(
      listener: (context, state) {
        if (state is FetchShipmentStatusSuccess) {
          context.pop();
        }

        if (state is FetchShipmentFailure) {
          TopSnackbar.dangerSnackbar(message: state.failure.message);
        }
      },
      builder: (context, state) {
        final onAction = switch (state) {
          FetchShipmentInProgress() => null,
          _ =>
            (String value) async => await context
                .read<ShipmentDetailCubit>()
                .fetchShipmentStatus(receiptNumber: value),
        };

        return ConfirmationInputDialog(
          onConfirm: onAction,
          fieldBuilder: (context, controller) => TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Hasil Scan'),
          ),
          actionText: 'Cari',
          body: 'Silakan scan nomor resi menggunakan scanner',
          title: 'Cari Resi',
        );
      },
    );
  }
}
