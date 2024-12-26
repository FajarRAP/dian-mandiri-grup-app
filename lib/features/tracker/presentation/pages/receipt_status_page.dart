import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/helpers.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/action_button.dart';
import '../widgets/check_receipt_from_scanner_alert_dialog.dart';
import '../widgets/detail_ship_info_item.dart';
import '../widgets/expandable_fab.dart';

class ReceiptStatusPage extends StatefulWidget {
  const ReceiptStatusPage({super.key});

  @override
  State<ReceiptStatusPage> createState() => _ReceiptStatusPageState();
}

class _ReceiptStatusPageState extends State<ReceiptStatusPage> {
  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Status Resi')),
      body: Center(
        child: BlocBuilder<ShipmentCubit, ShipmentState>(
          buildWhen: (previous, current) => current is FetchShipmentDetail,
          builder: (context, state) {
            if (state is FetchShipmentDetailLoading) {
              return const CircularProgressIndicator();
            }

            if (state is FetchShipmentDetailLoaded) {
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
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Status',
                      value: state.shipmentDetail.stage,
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Tanggal Scan',
                      value: dateFormat.format(state.shipmentDetail.date.toLocal()),
                    ),
                  ],
                ),
              );
            }

            if (state is FetchShipmentDetailError) {
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
