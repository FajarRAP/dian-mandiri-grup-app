import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/snackbar.dart';
import '../cubit/ship_cubit.dart';

class DeleteDataAlertDialog extends StatelessWidget {
  const DeleteDataAlertDialog({
    super.key,
    required this.stageId,
    required this.shipId,
  });

  final int stageId;
  final int shipId;

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();

    return AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: const Text('Yakin ingin menghapus resi ini?'),
      actions: <Widget>[
        TextButton(
          onPressed: context.pop,
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async => await shipCubit.deleteShip(shipId),
          child: BlocConsumer<ShipCubit, ShipState>(
            buildWhen: (previous, current) => current is DeleteShip,
            listenWhen: (previous, current) => current is DeleteShip,
            listener: (context, state) {
              if (state is DeleteShipSuccess) {
                context.pop();
                flushbar(context, state.message);
                shipCubit.getShips(stageId, DateTime.now());
              }
              if (state is DeleteShipError) {
                flushbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is DeleteShipLoading) {
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
