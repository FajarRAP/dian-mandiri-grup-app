import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/confirmation_dialog.dart';
import '../cubit/shipment_list/shipment_list_cubit.dart';

class DeleteShipmentDialog extends StatelessWidget {
  const DeleteShipmentDialog({super.key, required this.shipmentId});

  final String shipmentId;

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
          _ => () => context.read<ShipmentListCubit>().deleteShipment(
            shipmentId: shipmentId,
          ),
        };

        return ConfirmationDialog(
          onAction: onAction,
          actionText: 'Hapus',
          body: 'Yakin ingin menghapus resi ini?',
          title: 'Hapus Resi',
        );
      },
    );
  }
}
