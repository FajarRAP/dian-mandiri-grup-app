import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../cubit/shipment_detail/shipment_detail_cubit.dart';

class UpdateShipmentDocumentPage extends StatelessWidget {
  const UpdateShipmentDocumentPage({
    super.key,
    required this.imagePath,
    required this.shipmentId,
    required this.stage,
  });

  final String imagePath;
  final String shipmentId;
  final String stage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Gambar Resi')),
      body: ListView(
        padding: const .all(16),
        children: <Widget>[
          Image.file(File(imagePath)),
          const Gap(24),
          BlocConsumer<ShipmentDetailCubit, ShipmentDetailState>(
            listener: (context, state) {
              if (state is ActionSuccess) {
                TopSnackbar.successSnackbar(message: state.message);
                context
                  ..pop()
                  ..read<ShipmentDetailCubit>().fetchShipment(
                    shipmentId: shipmentId,
                  );
              }

              if (state is ActionFailure) {
                TopSnackbar.dangerSnackbar(message: state.failure.message);
              }
            },
            builder: (context, state) {
              final onPressed = switch (state) {
                ActionInProgress() => null,
                _ =>
                  () async => await context
                      .read<ShipmentDetailCubit>()
                      .updateShipmentDocument(
                        shipmentId: shipmentId,
                        documentPath: imagePath,
                        stage: stage,
                      ),
              };

              return PrimaryButton(
                onPressed: onPressed,
                child: const Text('Unggah'),
              );
            },
          ),
        ],
      ),
    );
  }
}
