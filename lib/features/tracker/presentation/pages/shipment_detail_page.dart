import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/models/shipment_detail_model.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/image_not_found.dart';
import '../widgets/ship_detail_info_item.dart';

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
        if (state is FetchShipmentDetailError) {
          scaffoldMessengerKey.currentState?.showSnackBar(
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
                child: CircularProgressIndicator(),
              );
            }

            if (state is FetchShipmentDetailLoaded) {
              final shipmentDetail =
                  state.shipmentDetail as ShipmentDetailModel;
              final isHavePermission =
                  authCubit.user.id == shipmentDetail.stage.user.id;
              // final isSuperAdmin =
              //     authCubit.user.permissions.contains(superAdminPermission);
              shipmentCubit.shipmentDetail =
                  state.shipmentDetail as ShipmentDetailModel;

              return RefreshIndicator(
                onRefresh: () async => await shipmentCubit.fetchShipmentById(
                    shipmentId: shipmentId),
                displacement: 10,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
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
                    if (isHavePermission) ...[
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push(cameraRoute),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Upload Resi'),
                        ),
                      )
                    ],
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Informasi Resi',
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    ShipDetailInfoItem(
                      label: 'Di Scan Oleh',
                      value: shipmentDetail.stage.user.name,
                    ),
                    const SizedBox(height: 8),
                    ShipDetailInfoItem(
                      label: 'Nomor Resi',
                      value: shipmentDetail.receiptNumber,
                    ),
                    const SizedBox(height: 8),
                    ShipDetailInfoItem(
                      label: 'Nama Ekspedisi',
                      value: shipmentDetail.courier,
                    ),
                    const SizedBox(height: 8),
                    ShipDetailInfoItem(
                      label: 'Stage',
                      value: shipmentDetail.stage.stage,
                    ),
                    const SizedBox(height: 8),
                    ShipDetailInfoItem(
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
