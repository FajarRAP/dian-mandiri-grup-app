import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../data/models/shipment_detail_model.dart';
import '../cubit/shipment_cubit.dart';

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({
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
      body: Column(
        children: [
          Image.file(file),
          const SizedBox(height: 24),
          BlocConsumer<ShipmentCubit, ShipmentState>(
            buildWhen: (previous, current) => current is InsertShipmentDocument,
            listener: (context, state) {
              if (state is InsertShipmentDocumentLoaded) {
                scaffoldMessengerKey.currentState
                    ?.showSnackBar(successSnackbar(state.message));
                shipmentCubit.fetchShipmentById(shipmentId: shipmentId);
                context
                  ..pop()
                  ..pop();
              }

              if (state is InsertShipmentDocumentError) {
                scaffoldMessengerKey.currentState
                    ?.showSnackBar(dangerSnackbar(state.message));
              }
            },
            builder: (context, state) {
              if (state is InsertShipmentDocumentLoading) {
                return const CircularProgressIndicator();
              }

              return ElevatedButton(
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
