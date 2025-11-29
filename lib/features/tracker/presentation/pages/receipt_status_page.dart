import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../common/constants/app_permissions.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/presentation/widgets/expandable_fab/action_button.dart';
import '../../../../core/presentation/widgets/expandable_fab/expandable_fab.dart';
import '../../../../core/presentation/widgets/loading_indicator.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/buttons/danger_button.dart';
import '../../../../service_container.dart';
import '../../domain/entities/shipment_history_entity.dart';
import '../../domain/entities/stage_entity.dart';
import '../cubit/shipment_detail/shipment_detail_cubit.dart';
import '../cubit/shipment_list/shipment_list_cubit.dart';
import '../widgets/cancel_shipment_dialog.dart';
import '../widgets/check_receipt_status_from_scanner_dialog.dart';

class ReceiptStatusPage extends StatelessWidget {
  const ReceiptStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Status Resi')),
      body: BlocBuilder<ShipmentDetailCubit, ShipmentDetailState>(
        builder: (context, state) {
          return switch (state) {
            FetchShipmentInProgress() => const LoadingIndicator(),
            FetchShipmentStatusSuccess(:final shipment) => _SuccessWidget(
              shipment: shipment,
            ),
            FetchShipmentFailure(:final failure) => Center(
              child: Text(failure.message, style: textTheme.titleMedium),
            ),
            _ => Center(
              child: Text('Scan terlebih dahulu', style: textTheme.titleMedium),
            ),
          };
        },
      ),
      floatingActionButton: const _FAB(),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.shipment});

  final ShipmentHistoryEntity shipment;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final isSuperAdmin = context.read<UserCubit>().can(
      AppPermissions.superAdmin,
    );
    final isCanceled = shipment.stages.any(
      (stage) => stage.stage == cancelStage,
    );

    return Center(
      child: SingleChildScrollView(
        child: Card(
          color: context.colorScheme.surfaceContainerLow,
          elevation: 2,
          margin: const .all(16),
          shape: RoundedRectangleBorder(borderRadius: .circular(16)),
          child: Column(
            crossAxisAlignment: .stretch,
            children: <Widget>[
              // Header
              Container(
                decoration: BoxDecoration(
                  borderRadius: const .vertical(top: .circular(16)),
                  color: context.colorScheme.primary,
                ),
                padding: const .symmetric(vertical: 16),
                width: .infinity,
                child: Text(
                  'Informasi Resi',
                  style: textTheme.headlineSmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontWeight: .w700,
                  ),
                  textAlign: .center,
                ),
              ),
              const Gap(16),
              // Shipment Detail
              Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(12),
                  boxShadow: cardBoxShadow,
                  color: context.colorScheme.surfaceContainerLowest,
                ),
                padding: const .all(16),
                margin: const .symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.receipt_long,
                          color: context.colorScheme.primary,
                        ),
                        const Gap(8),
                        Text(
                          'Detail Pengiriman',
                          style: textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: .w700,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _ReceiptStatusInfoRow(
                      icon: Icons.numbers,
                      label: 'Nomor Resi',
                      trailing: IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: shipment.receiptNumber),
                          );
                          const message = 'Nomor Resi disalin ke clipboard';
                          TopSnackbar.successSnackbar(message: message);
                        },
                        icon: Icon(
                          Icons.copy,
                          size: 16,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      value: shipment.receiptNumber,
                    ),
                    const Gap(12),
                    _ReceiptStatusInfoRow(
                      icon: Icons.local_shipping,
                      label: 'Nama Ekspedisi',
                      value: shipment.courier,
                    ),
                  ],
                ),
              ),
              const Gap(12),
              // Cancel Button
              if (isSuperAdmin && !isCanceled)
                Padding(
                  padding: const .symmetric(horizontal: 16),
                  child: _CancelButton(receiptNumber: shipment.receiptNumber),
                ),
              const Gap(12),
              // Shipment Histories
              Padding(
                padding: const .symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.history, color: context.colorScheme.primary),
                    const Gap(8),
                    Text(
                      'Riwayat Status',
                      style: textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: .w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              // Timeline
              ListView.separated(
                itemBuilder: (context, index) {
                  final stage = shipment.stages[index];
                  final isLast = index == shipment.stages.length - 1;

                  return _ReceiptStatusTimeline(isLast: isLast, stage: stage);
                },
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: shipment.stages.length,
                padding: const .symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB();

  @override
  Widget build(BuildContext context) {
    final shipmentDetailCubit = context.read<ShipmentDetailCubit>();

    return ExpandableFAB(
      distance: 90,
      children: <Widget>[
        ActionButton(
          onPressed: () async {
            final receiptNumber = await SimpleBarcodeScanner.scanBarcode(
              context,
              cameraFace: CameraFace.back,
              cancelButtonText: 'Batal',
              isShowFlashIcon: true,
            );

            if (receiptNumber == null) return;

            await shipmentDetailCubit.fetchShipmentStatus(
              receiptNumber: receiptNumber,
            );
          },
          icon: Icons.document_scanner_rounded,
        ),
        ActionButton(
          onPressed: () => showDialog(
            builder: (_) => BlocProvider.value(
              value: context.read<ShipmentDetailCubit>(),
              child: const CheckReceiptStatusFromScannerDialog(),
            ),
            context: context,
          ),
          icon: Icons.barcode_reader,
        ),
      ],
    );
  }
}

class _ReceiptStatusInfoRow extends StatelessWidget {
  const _ReceiptStatusInfoRow({
    required this.icon,
    required this.label,
    this.trailing,
    required this.value,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: .circular(8),
            color: context.colorScheme.primaryFixed,
          ),
          padding: const .all(8),
          child: Icon(icon, color: context.colorScheme.primary, size: 20),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(fontWeight: .w600),
              ),
            ],
          ),
        ),
        trailing ?? const SizedBox(),
      ],
    );
  }
}

class _ReceiptStatusTimeline extends StatelessWidget {
  const _ReceiptStatusTimeline({required this.isLast, required this.stage});

  final bool isLast;
  final StageEntity stage;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final stageName = _evaluateStage(stage.stage);

    return Row(
      crossAxisAlignment: .start,
      children: <Widget>[
        Column(
          children: <Widget>[
            // Timeline Dot
            Container(
              decoration: BoxDecoration(
                border: .all(
                  color: context.colorScheme.surfaceContainerLowest,
                  width: 3,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 5,
                    color: context.colorScheme.primary.withValues(alpha: .3),
                  ),
                ],
                color: context.colorScheme.primary.withValues(alpha: .6),
                shape: .circle,
              ),
              height: 24,
              width: 24,
              child: Icon(
                Icons.circle,
                color: context.colorScheme.surfaceContainerLowest,
                size: 12,
              ),
            ),
            if (!isLast)
              // Timeline Line
              Container(
                color: context.colorScheme.primary.withValues(alpha: .3),
                height: 60,
                width: 2,
              ),
          ],
        ),
        const Gap(16),
        // Timeline Card
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              boxShadow: cardBoxShadow,
              color: context.colorScheme.surfaceContainerLowest,
            ),
            padding: const .symmetric(horizontal: 16, vertical: 10),
            width: .infinity,
            child: Column(
              crossAxisAlignment: .start,
              children: <Widget>[
                Text(
                  stageName,
                  style: textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.primary.withValues(alpha: .8),
                    fontWeight: .w700,
                  ),
                ),
                const Gap(8),
                Row(
                  children: <Widget>[
                    Icon(Icons.person, color: Colors.grey.shade600, size: 16),
                    const Gap(4),
                    Text(
                      stage.user.name,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const Gap(4),
                    Text(
                      stage.date.toLocal().toDMYHMS,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.receiptNumber});

  final String receiptNumber;

  @override
  Widget build(BuildContext context) {
    return DangerButton(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => BlocProvider(
          create: (context) => getIt<ShipmentListCubit>(),
          child: BlocListener<ShipmentListCubit, ShipmentListState>(
            listener: (context, state) {
              if (state.actionStatus == .failure) {
                TopSnackbar.dangerSnackbar(message: state.failure!.message);
              }

              if (state.actionStatus == .success) {
                TopSnackbar.successSnackbar(message: state.message!);
                context.pop();
              }
            },
            child: CancelShipmentDialog(receiptNumber: receiptNumber),
          ),
        ),
      ),
      child: const Text('Cancel Resi'),
    );
  }
}

String _evaluateStage(String stage) {
  switch (stage) {
    case scanStage:
      return 'Scan';
    case pickUpStage:
      return 'Ambil Barang';
    case checkStage:
      return 'Checker';
    case packStage:
      return 'Packing';
    case sendStage:
      return 'Kirim';
    case returnStage:
      return 'Retur';
    case cancelStage:
      return 'Cancel';
    default:
      return 'Tidak Diketahui';
  }
}
