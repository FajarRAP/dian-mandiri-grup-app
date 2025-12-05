import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/constants/app_constants.dart';
import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../cubit/create_shipment/create_shipment_cubit.dart';

class CancelShipmentDialog extends StatelessWidget {
  const CancelShipmentDialog({super.key, required this.receiptNumber});

  final String receiptNumber;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateShipmentCubit, CreateShipmentState>(
      listener: (context, state) {
        if (state.status == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
          context.pop(true);
        }

        if (state.status == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        }
      },
      builder: (context, state) {
        final onAction = switch (state.status) {
          .inProgress => null,
          _ =>
            () async =>
                await context.read<CreateShipmentCubit>().createShipment(
                  receiptNumber: receiptNumber,
                  stage: AppConstants.cancelStage,
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
