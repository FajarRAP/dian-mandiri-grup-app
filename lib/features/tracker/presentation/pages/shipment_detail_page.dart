import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/constants/app_permissions.dart';
import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/presentation/widgets/loading_indicator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/presentation/widgets/buttons/primary_button.dart';
import '../../../../core/presentation/widgets/image_picker_bottom_sheet.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../cubit/shipment_detail/shipment_detail_cubit.dart';
import '../widgets/image_not_found.dart';

class ShipmentDetailPage extends StatefulWidget {
  const ShipmentDetailPage({super.key, required this.shipmentId});

  final String shipmentId;

  @override
  State<ShipmentDetailPage> createState() => _ShipmentDetailPageState();
}

class _ShipmentDetailPageState extends State<ShipmentDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShipmentDetailCubit>().fetchShipment(
      shipmentId: widget.shipmentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Resi')),
      body: BlocConsumer<ShipmentDetailCubit, ShipmentDetailState>(
        listener: (context, state) {
          if (state is FetchShipmentFailure) {
            TopSnackbar.dangerSnackbar(message: state.failure.message);
          }
        },
        builder: (context, state) {
          return switch (state) {
            FetchShipmentInProgress() => const LoadingIndicator(),
            FetchShipmentSuccess(:final shipment) => _SuccessWidget(
              shipment: shipment,
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.shipment});

  final ShipmentDetailEntity shipment;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final shipmentDetailCubit = context.read<ShipmentDetailCubit>();
    final user = context.read<UserCubit>().user;
    final isSuperAdmin = user.can(AppPermissions.superAdmin);
    final isHasUploadPermission = user.id == shipment.user.id;

    return RefreshIndicator(
      onRefresh: () async =>
          await shipmentDetailCubit.fetchShipment(shipmentId: shipment.id),
      displacement: 10,
      child: ListView(
        padding: const .all(16),
        children: <Widget>[
          Center(
            child: ClipRRect(
              borderRadius: .circular(8),
              child: Image.network(
                '${shipment.document}',
                scale: 2,
                errorBuilder: (context, error, stackTrace) =>
                    const ImageNotFound(),
              ),
            ),
          ),
          if (isSuperAdmin || isHasUploadPermission) ...[
            const Gap(10),
            Center(
              child: PrimaryButton(
                onPressed: () => showModalBottomSheet(
                  builder: (_) => ImagePickerBottomSheet(
                    onPicked: (image) => context.pushNamed(
                      Routes.trackerPickedDocument,
                      extra: {
                        'image_path': image.path,
                        'shipment_id': shipment.id,
                        'stage': shipment.stage,
                        'cubit': context.read<ShipmentDetailCubit>(),
                      },
                    ),
                  ),
                  context: context,
                ),

                icon: const Icon(Icons.camera_alt),
                child: const Text('Upload Resi'),
              ),
            ),
          ],
          const Gap(24),
          const Divider(height: 1),
          const Gap(16),
          Text(
            'Informasi Resi',
            style: textTheme.headlineSmall?.copyWith(fontWeight: .w700),
          ),
          const Gap(12),
          _ShipmentDetailInfoRow(
            label: 'Di Scan Oleh',
            value: shipment.user.name,
          ),
          const Gap(8),
          _ShipmentDetailInfoRow(
            label: 'Nomor Resi',
            value: shipment.receiptNumber,
          ),
          const Gap(8),
          _ShipmentDetailInfoRow(
            label: 'Nama Ekspedisi',
            value: shipment.courier,
          ),
          const Gap(8),
          _ShipmentDetailInfoRow(label: 'Stage', value: shipment.stage),
          const Gap(8),
          _ShipmentDetailInfoRow(
            label: 'Tanggal Scan',
            value: shipment.date.toLocal().toDMYHMS,
          ),
        ],
      ),
    );
  }
}

class _ShipmentDetailInfoRow extends StatelessWidget {
  const _ShipmentDetailInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
        SelectableText(
          value,
          style: textTheme.bodyLarge?.copyWith(fontWeight: .w500),
        ),
      ],
    );
  }
}
