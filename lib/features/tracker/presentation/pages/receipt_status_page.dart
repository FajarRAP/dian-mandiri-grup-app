import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/buttons/danger_button.dart';
import '../../../../core/widgets/expanded_fab/action_button.dart';
import '../../../../core/widgets/expanded_fab/expandable_fab.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/cancel_shipment_dialog.dart';
import '../widgets/check_receipt_status_from_scanner_dialog.dart';
import '../widgets/receipt_status_history_timeline.dart';
import '../widgets/receipt_status_info_row.dart';

class ReceiptStatusPage extends StatelessWidget {
  const ReceiptStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authCubit = context.read<AuthCubit>();
    final shipmentCubit = context.read<ShipmentCubit>();
    final textTheme = theme.textTheme;
    final permissions = authCubit.user.permissions;
    final isSuperAdmin = permissions.contains(superAdminPermission);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Resi'),
      ),
      body: Center(
        child: BlocConsumer<ShipmentCubit, ShipmentState>(
          buildWhen: (previous, current) => current is FetchReceiptStatus,
          listenWhen: (previous, current) => current is FetchReceiptStatus,
          listener: (context, state) {
            if (state is FetchReceiptStatusError) {
              switch (state.failure.statusCode) {
                case 404:
                  return TopSnackbar.dangerSnackbar(
                      message: state.failure.message);
              }
            }
          },
          builder: (context, state) {
            if (state is FetchReceiptStatusLoading) {
              return const CircularProgressIndicator.adaptive();
            }

            if (state is FetchReceiptStatusLoaded) {
              final shipmentHistory = state.shipmentHistory;
              final stages = shipmentHistory.stages;
              final isCanceled = shipmentHistory.stages
                  .any((stage) => stage.stage == cancelStage);

              return SingleChildScrollView(
                child: Card(
                  color: MaterialColors.surfaceContainerLow,
                  elevation: 2,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: <Widget>[
                      // Header
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          color: CustomColors.primaryNormal,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        child: Text(
                          'Informasi Resi',
                          style: textTheme.headlineSmall?.copyWith(
                            color: MaterialColors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListView(
                        padding: const EdgeInsets.all(16),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          // Shipment Detail
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: cardBoxShadow,
                              color: MaterialColors.surfaceContainerLowest,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.receipt_long,
                                      color: CustomColors.primaryNormal,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Detail Pengiriman',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: CustomColors.primaryNormal,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                ReceiptStatusInfoRow(
                                  icon: Icons.numbers,
                                  label: 'Nomor Resi',
                                  trailing: IconButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: shipmentHistory.receiptNumber));
                                      const message =
                                          'Nomor Resi disalin ke clipboard';
                                      TopSnackbar.successSnackbar(
                                          message: message);
                                    },
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 16,
                                      color: CustomColors.primaryNormal,
                                    ),
                                  ),
                                  value: shipmentHistory.receiptNumber,
                                ),
                                const SizedBox(height: 12),
                                ReceiptStatusInfoRow(
                                  icon: Icons.local_shipping,
                                  label: 'Nama Ekspedisi',
                                  value: shipmentHistory.courier,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Cancel Button
                          if (isSuperAdmin && !isCanceled) ...[
                            const SizedBox(height: 12),
                            DangerButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) =>
                                    BlocListener<ShipmentCubit, ShipmentState>(
                                  listener: (context, state) {
                                    if (state is InsertShipmentLoaded) {
                                      shipmentCubit
                                          .fetchShipmentByReceiptNumber(
                                        receiptNumber:
                                            shipmentHistory.receiptNumber,
                                      );
                                    }
                                  },
                                  child: CancelShipmentDialog(
                                    receiptNumber:
                                        shipmentHistory.receiptNumber,
                                  ),
                                ),
                              ),
                              child: const Text('Cancel Resi'),
                            ),
                            const SizedBox(height: 12),
                          ],
                          const SizedBox(height: 12),
                          // Shipment Histories
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.history,
                                color: CustomColors.primaryNormal,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Riwayat Status',
                                style: textTheme.titleMedium?.copyWith(
                                  color: CustomColors.primaryNormal,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            itemBuilder: (context, index) {
                              final stage = stages[index];
                              final isLast = index == stages.length - 1;

                              return ReceiptStatusHistoryTimeline(
                                isLast: isLast,
                                stage: stage,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemCount: stages.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is FetchReceiptStatusError) {
              return Text(
                'Silakan coba lagi',
                style: textTheme.titleMedium,
              );
            }

            return Text(
              'Scan terlebih dahulu',
              style: textTheme.titleMedium,
            );
          },
        ),
      ),
      floatingActionButton: ExpandableFAB(
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

              await shipmentCubit.fetchShipmentByReceiptNumber(
                  receiptNumber: receiptNumber);
            },
            icon: Icons.document_scanner_rounded,
          ),
          ActionButton(
            onPressed: () => showDialog(
              builder: (context) => const CheckReceiptStatusFromScannerDialog(),
              context: context,
            ),
            icon: Icons.barcode_reader,
          ),
        ],
      ),
    );
  }
}
