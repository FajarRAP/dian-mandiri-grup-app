import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/buttons/danger_button.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/confirmation_input_dialog.dart';
import '../../../../core/widgets/expanded_fab/action_button.dart';
import '../../../../core/widgets/expanded_fab/expandable_fab.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/models/shipment_detail_status_model.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/receipt_status_history_timeline.dart';
import '../widgets/receipt_status_info_row.dart';

class ReceiptStatusPage extends StatelessWidget {
  const ReceiptStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final authCubit = context.read<AuthCubit>();
    final shipmentCubit = context.read<ShipmentCubit>();
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
              final shipmentDetail =
                  state.shipmentDetail as ShipmentDetailStatusModel;
              final stages = shipmentDetail.stages;
              final isCanceled = shipmentDetail.stages
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
                        decoration: BoxDecoration(
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
                                          text: state
                                              .shipmentDetail.receiptNumber));
                                      final message =
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
                                  value: state.shipmentDetail.receiptNumber,
                                ),
                                const SizedBox(height: 12),
                                ReceiptStatusInfoRow(
                                  icon: Icons.local_shipping,
                                  label: 'Nama Ekspedisi',
                                  value: state.shipmentDetail.courier,
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
                                    BlocConsumer<ShipmentCubit, ShipmentState>(
                                  buildWhen: (previous, current) =>
                                      current is InsertShipment,
                                  listenWhen: (previous, current) =>
                                      current is InsertShipment,
                                  listener: (context, state) {
                                    if (state is InsertShipmentLoaded) {
                                      TopSnackbar.successSnackbar(
                                          message: state.message);
                                      context.pop();
                                      shipmentCubit
                                          .fetchShipmentByReceiptNumber(
                                        receiptNumber:
                                            shipmentDetail.receiptNumber,
                                      );
                                    }

                                    if (state is InsertShipmentError) {
                                      TopSnackbar.dangerSnackbar(
                                          message: state.failure.message);
                                    }
                                  },
                                  builder: (context, state) {
                                    return ConfirmationDialog(
                                      onAction: () async =>
                                          await shipmentCubit.insertShipment(
                                        receiptNumber:
                                            shipmentDetail.receiptNumber,
                                        stage: cancelStage,
                                      ),
                                      actionText: 'Cancel',
                                      body: 'Yakin ingin cancel resi ini?',
                                      title: 'Cancel Resi',
                                    );
                                  },
                                ),
                                // AlertDialog(
                                //   title: const Text('Konfirmasi'),
                                //   content: const Text(
                                //     'Apakah Anda yakin ingin membatalkan resi ini?',
                                //   ),
                                //   actions: <Widget>[
                                //     TextButton(
                                //       onPressed: context.pop,
                                //       child: const Text('Tidak'),
                                //     ),
                                //     BlocConsumer<ShipmentCubit, ShipmentState>(
                                //       listener: (context, cancelState) {
                                //         if (cancelState
                                //             is InsertShipmentLoaded) {
                                //           context.pop();
                                //           shipmentCubit
                                //               .fetchShipmentByReceiptNumber(
                                //             receiptNumber: state
                                //                 .shipmentDetail.receiptNumber,
                                //           );
                                //         }
                                //         if (cancelState
                                //             is InsertShipmentError) {
                                //           context.pop();
                                //           scaffoldMessengerKey.currentState
                                //               ?.showSnackBar(
                                //             dangerSnackbar(
                                //                 cancelState.failure.message),
                                //           );
                                //         }
                                //       },
                                //       builder: (context, cancelState) {
                                //         if (cancelState
                                //             is InsertShipmentLoading) {
                                //           return const CircularProgressIndicator
                                //               .adaptive();
                                //         }

                                //         return TextButton(
                                //           onPressed: () =>
                                //               shipmentCubit.insertShipment(
                                //             receiptNumber: state
                                //                 .shipmentDetail.receiptNumber,
                                //             stage: cancelStage,
                                //           ),
                                //           child: const Text('Ya'),
                                //         );
                                //       },
                                //     ),
                                //   ],
                                // ),
                              ),
                              child: const Text('Cancel Resi'),
                            ),
                            const SizedBox(height: 12),
                          ],
                          const SizedBox(height: 12),
                          // Shipment Histories
                          Row(
                            children: <Widget>[
                              Icon(
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
              builder: (context) => BlocConsumer<ShipmentCubit, ShipmentState>(
                buildWhen: (previous, current) => current is FetchReceiptStatus,
                listenWhen: (previous, current) =>
                    current is FetchReceiptStatus,
                listener: (context, state) {
                  if (state is FetchReceiptStatusLoaded) {
                    context.pop();
                  }
                },
                builder: (context, state) {
                  if (state is FetchReceiptStatusLoading) {
                    return _buildConfirmationInputDialog(
                        shipmentCubit: shipmentCubit);
                  }

                  return _buildConfirmationInputDialog(
                      onAction: (value) async => await shipmentCubit
                          .fetchShipmentByReceiptNumber(receiptNumber: value),
                      shipmentCubit: shipmentCubit);
                },
              ),
              context: context,
            ),
            icon: Icons.barcode_reader,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationInputDialog({
    void Function(String value)? onAction,
    required ShipmentCubit shipmentCubit,
  }) {
    return ConfirmationInputDialog(
      onAction: onAction,
      actionText: 'Cari',
      body: 'Silakan scan nomor resi menggunakan scanner',
      textFormFieldConfig: TextFormFieldConfig(
        onFieldSubmitted: (value) =>
            shipmentCubit.fetchShipmentByReceiptNumber(receiptNumber: value),
        autoFocus: true,
        decoration: const InputDecoration(
          labelText: 'Hasil Scan',
        ),
        textInputAction: TextInputAction.send,
      ),
      title: 'Cari Resi',
    );
  }
}
