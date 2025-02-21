import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/helpers.dart';
import '../../data/models/shipment_detail_status_model.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/action_button.dart';
import '../widgets/check_receipt_from_scanner_alert_dialog.dart';
import '../widgets/detail_ship_info_item.dart';
import '../widgets/expandable_fab.dart';

class ReceiptStatusPage extends StatelessWidget {
  const ReceiptStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Status Resi')),
      body: Center(
        child: BlocBuilder<ShipmentCubit, ShipmentState>(
          buildWhen: (previous, current) => current is FetchReceiptStatus,
          builder: (context, state) {
            if (state is FetchReceiptStatusLoading) {
              return const CircularProgressIndicator();
            }

            if (state is FetchReceiptStatusLoaded) {
              final stages =
                  (state.shipmentDetail as ShipmentDetailStatusModel).stages;
              return Card(
                margin: const EdgeInsets.all(16),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(12),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Text(
                      'Informasi Resi',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Nomor Resi',
                      value: state.shipmentDetail.receiptNumber,
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Nama Karyawan',
                      value: state.shipmentDetail.user.name,
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Nama Ekspedisi',
                      value: state.shipmentDetail.courier,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Riwayat Status',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        final stage = stages[index];
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stage.stage,
                                style: textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateTimeFormat.format(stage.date.toLocal()),
                                style: textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: stages.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            }

            if (state is FetchReceiptStatusError) {
              return Text(state.message, style: textTheme.titleMedium);
            }

            return Text('Scan terlebih dahulu', style: textTheme.titleMedium);
          },
        ),
      ),
      floatingActionButton: ExpandableFabMine(
        distance: 90,
        children: [
          ActionButton(
            onPressed: () async {
              final receiptNumber = await BarcodeScanner.scan();

              if (receiptNumber.rawContent.isEmpty) return;

              await shipmentCubit.fetchShipmentByReceiptNumber(
                  receipNumber: receiptNumber.rawContent);
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
