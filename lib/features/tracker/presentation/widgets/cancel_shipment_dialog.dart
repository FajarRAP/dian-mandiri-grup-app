import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../cubit/shipment_list/shipment_list_cubit.dart';

class CancelShipmentDialog extends StatelessWidget {
  const CancelShipmentDialog({super.key, required this.receiptNumber});

  final String receiptNumber;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShipmentListCubit, ShipmentListState>(
      listener: (context, state) {
        if (state.actionStatus == .success) {
          context.pop();
        }
      },
      builder: (context, state) {
        final onAction = switch (state.actionStatus) {
          .inProgress => null,
          _ =>
            () async => await context.read<ShipmentListCubit>().createShipment(
              receiptNumber: receiptNumber,
              stage: cancelStage,
            ),
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
