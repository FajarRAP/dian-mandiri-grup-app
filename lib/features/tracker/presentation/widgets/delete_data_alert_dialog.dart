import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/widgets/alert_dialog_snackbar_wrapper.dart';
import '../../domain/entities/shipment_entity.dart';
import '../cubit/shipment_cubit.dart';

class DeleteDataAlertDialog extends StatelessWidget {
  const DeleteDataAlertDialog({
    super.key,
    required this.shipment,
    required this.stage,
    required this.date,
  });

  final ShipmentEntity shipment;
  final String stage;
  final String date;

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();

    return AlertDialogSnackbarWrapper(
      dialog: AlertDialog(
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
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    successSnackbar(
                      state.message,
                      EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery.sizeOf(context).height - 175,
                      ),
                    ),
                  );
                  shipmentCubit.fetchShipments(
                    date: date,
                    stage: stage,
                  );
                }

                if (state is DeleteShipmentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    dangerSnackbar(
                      state.message,
                      EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery.sizeOf(context).height - 175,
                      ),
                    ),
                  );
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
      ),
    );
  }
}
