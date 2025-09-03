import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../cubit/shipment_cubit.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({
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
    final shipmentCubit = context.read<ShipmentCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Gambar Resi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Image.file(File(imagePath)),
          const SizedBox(height: 24),
          BlocConsumer<ShipmentCubit, ShipmentState>(
            buildWhen: (previous, current) => current is InsertShipmentDocument,
            listener: (context, state) {
              if (state is InsertShipmentDocumentLoaded) {
                TopSnackbar.successSnackbar(message: state.message);
                context.pop();
              }

              if (state is InsertShipmentDocumentError) {
                TopSnackbar.dangerSnackbar(message: state.message);
              }
            },
            builder: (context, state) {
              if (state is InsertShipmentDocumentLoading) {
                return const PrimaryButton(
                  child: Text('Unggah'),
                );
              }

              return PrimaryButton(
                onPressed: () async =>
                    await shipmentCubit.insertShipmentDocument(
                  shipmentId: shipmentId,
                  documentPath: imagePath,
                  stage: stage,
                ),
                child: const Text('Unggah'),
              );
            },
          ),
        ],
      ),
    );
  }
}
