import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../data/models/shipment_detail_model.dart';
import '../cubit/shipment_cubit.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({
    super.key,
    required this.image,
  });

  final XFile image;

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final shipmentId = shipmentCubit.shipmentDetail.id;
    final file = File(image.path);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Gambar Resi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Image.file(file),
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
                  image: image,
                  stage: (shipmentCubit.shipmentDetail as ShipmentDetailModel)
                      .stage
                      .stage,
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
