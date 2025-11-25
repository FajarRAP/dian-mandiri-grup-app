import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../cubit/shipment_cubit.dart';

class CancelShipmentDialog extends StatelessWidget {
  const CancelShipmentDialog({
    super.key,
    required this.receiptNumber,
  });

  final String receiptNumber;

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    return BlocConsumer<ShipmentCubit, ShipmentState>(
      bloc: shipmentCubit,
      buildWhen: (previous, current) => current is InsertShipment,
      listenWhen: (previous, current) => current is InsertShipment,
      listener: (context, state) {
        if (state is InsertShipmentLoaded) {
          TopSnackbar.successSnackbar(message: state.message);
          context.pop();
        }

        if (state is InsertShipmentError) {
          TopSnackbar.dangerSnackbar(message: state.failure.message);
        }
      },
      builder: (context, state) {
        final onAction = switch (state) {
          InsertShipmentLoading() => null,
          _ => () async => await shipmentCubit.insertShipment(
              receiptNumber: receiptNumber, stage: cancelStage),
        };

        return ConfirmationDialog(
          onAction: onAction,
          actionText: 'Cancel',
          body: 'Yakin ingin cancel resi ini?',
          title: 'Cancel Resi',
        );
      },
    );
  }
}
