import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/helpers.dart';
import '../../domain/entities/shipment_entity.dart';
import '../cubit/shipment_cubit.dart';

class DeleteDataAlertDialog extends StatelessWidget {
  const DeleteDataAlertDialog({
    super.key,
    required this.shipment,
    required this.stage,
  });

  final ShipmentEntity shipment;
  final String stage;

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final dateTimeNow = dateFormat.format(DateTime.now());

    return AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: const Text('Yakin ingin menghapus resi ini?'),
      actions: <Widget>[
        TextButton(onPressed: context.pop, child: const Text('Batal')),
        TextButton(
          onPressed: () async =>
              await shipmentCubit.deleteShipment(shipmentId: shipment.id),
          child: BlocConsumer<ShipmentCubit, ShipmentState>(
            buildWhen: (previous, current) => current is DeleteShipment,
            listenWhen: (previous, current) => current is DeleteShipment,
            listener: (context, state) {
              if (state is DeleteShipmentLoaded) {
                context.pop();
                flushbar(state.message);
                shipmentCubit.fetchShipments(date: dateTimeNow, stage: stage);
              }

              if (state is DeleteShipmentError) {
                flushbar(state.message);
              }
            },
            builder: (context, state) {
              if (state is DeleteShipmentLoading) {
                return const CircularProgressIndicator();
              }

              return const Text('Hapus');
            },
          ),
        ),
      ],
    );
  }
}
