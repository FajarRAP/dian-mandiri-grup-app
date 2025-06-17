import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/widgets/danger_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/models/shipment_detail_status_model.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/action_button.dart';
import '../widgets/check_receipt_from_scanner_alert_dialog.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/receipt_history_row.dart';
import '../widgets/receipt_info_row.dart';

class ReceiptStatusPage extends StatelessWidget {
  const ReceiptStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isSuperAdmin =
        authCubit.user.permissions.contains(superAdminPermission);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Resi'),
      ),
      body: Center(
        child: BlocBuilder<ShipmentCubit, ShipmentState>(
          buildWhen: (previous, current) => current is FetchReceiptStatus,
          builder: (context, state) {
            if (state is FetchReceiptStatusLoading) {
              return const CircularProgressIndicator();
            }

            if (state is FetchReceiptStatusLoaded) {
              final shipmentDetail =
                  state.shipmentDetail as ShipmentDetailStatusModel;
              final stages = shipmentDetail.stages;
              final isCanceled = shipmentDetail.stages
                  .any((stage) => stage.stage == cancelStage);

              return SingleChildScrollView(
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          color: Colors.green,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        child: Text(
                          'Informasi Resi',
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListView(
                        padding: const EdgeInsets.all(16),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black.withValues(alpha: 0.05),
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.receipt_long,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Detail Pengiriman',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                ReceiptInfoRow(
                                  icon: Icons.numbers,
                                  label: 'Nomor Resi',
                                  value: state.shipmentDetail.receiptNumber,
                                  isSelectable: true,
                                ),
                                const SizedBox(height: 12),
                                ReceiptInfoRow(
                                  icon: Icons.local_shipping,
                                  label: 'Nama Ekspedisi',
                                  value: state.shipmentDetail.courier,
                                ),
                              ],
                            ),
                          ),
                          if (isSuperAdmin && !isCanceled) ...[
                            const SizedBox(height: 24),
                            DangerButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin membatalkan resi ini?',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: context.pop,
                                      child: const Text('Tidak'),
                                    ),
                                    BlocConsumer<ShipmentCubit, ShipmentState>(
                                      listener: (context, cancelState) {
                                        if (cancelState
                                            is InsertShipmentLoaded) {
                                          context.pop();
                                          shipmentCubit
                                              .fetchShipmentByReceiptNumber(
                                            receipNumber: state
                                                .shipmentDetail.receiptNumber,
                                          );
                                        }
                                        if (cancelState
                                            is InsertShipmentError) {
                                          context.pop();
                                          scaffoldMessengerKey.currentState
                                              ?.showSnackBar(
                                            successSnackbar(
                                                cancelState.failure.message),
                                          );
                                        }
                                      },
                                      builder: (context, cancelState) {
                                        if (cancelState
                                            is InsertShipmentLoading) {
                                          return const CircularProgressIndicator
                                              .adaptive();
                                        }

                                        return TextButton(
                                          onPressed: () =>
                                              shipmentCubit.insertShipment(
                                            receiptNumber: state
                                                .shipmentDetail.receiptNumber,
                                            stage: cancelStage,
                                          ),
                                          child: const Text('Ya'),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              child: const Text('Cancel Resi'),
                            ),
                          ],
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Riwayat Status',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.green,
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

                              return ReceiptHistoryRow(
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

            return Text(
              'Scan terlebih dahulu',
              style: textTheme.titleMedium,
            );
          },
        ),
      ),
      floatingActionButton: ExpandableFAB(
        distance: 90,
        children: [
          ActionButton(
            onPressed: () async {
              final receiptNumber =
                  await SimpleBarcodeScanner.scanBarcode(context);

              if (receiptNumber == null) return;

              await shipmentCubit.fetchShipmentByReceiptNumber(
                  receipNumber: receiptNumber);
            },
            icon: Icons.document_scanner_rounded,
          ),
          ActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const CheckReceiptFromScannerAlertDialog(),
            ),
            icon: Icons.barcode_reader,
          ),
        ],
      ),
    );
  }
}
