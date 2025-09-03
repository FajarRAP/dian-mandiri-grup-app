import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/models/shipment_detail_model.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/image_not_found.dart';
import '../widgets/shipment_detail_info_row.dart';

class ShipmentDetailPage extends StatelessWidget {
  const ShipmentDetailPage({
    super.key,
    required this.shipmentId,
  });

  final String shipmentId;

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final authCubit = context.read<AuthCubit>();
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<ShipmentCubit, ShipmentState>(
      listener: (context, state) {
        if (state is InsertShipmentDocumentLoaded) {
          shipmentCubit.fetchShipmentById(shipmentId: shipmentId);
        }

        if (state is FetchShipmentDetailError) {
          TopSnackbar.dangerSnackbar(message: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Resi'),
        ),
        body: BlocBuilder<ShipmentCubit, ShipmentState>(
          bloc: shipmentCubit..fetchShipmentById(shipmentId: shipmentId),
          buildWhen: (previous, current) => current is FetchShipmentDetail,
          builder: (context, state) {
            if (state is FetchShipmentDetailLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchShipmentDetailLoaded) {
              final shipmentDetail =
                  state.shipmentDetail as ShipmentDetailModel;
              // final isSuperAdmin =
              //     authCubit.user.permissions.contains(superAdminPermission);
              final isHasUploadPermission =
                  authCubit.user.id == shipmentDetail.stage.user.id;

              return RefreshIndicator(
                onRefresh: () async => await shipmentCubit.fetchShipmentById(
                    shipmentId: shipmentId),
                displacement: 10,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '${state.shipmentDetail.document}',
                          scale: 2,
                          errorBuilder: (context, error, stackTrace) =>
                              const ImageNotFound(),
                        ),
                      ),
                    ),
                    if (isHasUploadPermission) ...[
                      const SizedBox(height: 10),
                      Center(
                        child: PrimaryButton(
                          onPressed: () => showModalBottomSheet(
                            builder: (context) => ImagePickerBottomSheet(
                              onPicked: (image) => context.push(
                                displayPictureRoute,
                                extra: {
                                  'image_path': image.path,
                                  'shipment_id': shipmentId,
                                  'stage': shipmentDetail.stage.stage,
                                },
                              ),
                            ),
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt),
                          child: const Text('Upload Resi'),
                        ),
                      )
                    ],
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Informasi Resi',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ShipmentDetailInfoRow(
                      label: 'Di Scan Oleh',
                      value: shipmentDetail.stage.user.name,
                    ),
                    const SizedBox(height: 8),
                    ShipmentDetailInfoRow(
                      label: 'Nomor Resi',
                      value: shipmentDetail.receiptNumber,
                    ),
                    const SizedBox(height: 8),
                    ShipmentDetailInfoRow(
                      label: 'Nama Ekspedisi',
                      value: shipmentDetail.courier,
                    ),
                    const SizedBox(height: 8),
                    ShipmentDetailInfoRow(
                      label: 'Stage',
                      value: shipmentDetail.stage.stage,
                    ),
                    const SizedBox(height: 8),
                    ShipmentDetailInfoRow(
                      label: 'Tanggal Scan',
                      value: dateTimeFormat
                          .format(shipmentDetail.stage.date.toLocal()),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
