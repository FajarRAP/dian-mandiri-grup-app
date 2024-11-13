import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/courier_identifier.dart';
import '../cubit/ship_cubit.dart';
import '../widgets/action_button.dart';
import '../widgets/check_receipt_from_camera_alert_dialog.dart';
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Resi'),
      ),
      body: Center(
        child: BlocBuilder<ShipCubit, ShipState>(
          builder: (context, state) {
            if (state is CheckReceiptStatusLoaded) {
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
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Nomor Resi',
                      value: state.ship.receipt,
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Nama Ekspedisi',
                      value: courierIdentifier(state.ship.receipt),
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Status',
                      value: _buildStatus(stage: state.ship.stage),
                    ),
                    const SizedBox(height: 8),
                    InfoItem(
                      label: 'Tanggal Scan',
                      value: state.ship.formattedDate,
                    ),
                  ],
                ),
              );
            }
            if (state is CheckReceiptStatusError) {
              return Text(
                'Nomor resi tidak ditemukan, silakan coba lagi',
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
      floatingActionButton: ExpandableFabMine(
        distance: 90,
        children: [
          ActionButton(
            onPressed: () async {
              final receiptNumber = await BarcodeScanner.scan();

              if (!context.mounted || receiptNumber.rawContent.isEmpty) return;

              showDialog(
                context: context,
                builder: (context) => CheckReceiptFromCameraAlertDialog(
                  receiptNumber: receiptNumber.rawContent,
                ),
              );
            },
            icon: Icons.document_scanner_rounded,
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    const CheckReceiptFromScannerAlertDialog(),
              );
            },
            icon: Icons.barcode_reader,
          ),
        ],
      ),
    );
  }

  String _buildStatus({required String stage}) {
    switch (stage) {
      case '2':
        return 'Scan Resi';
      case '3':
        return 'Scan Ambil Resi';
      case '4':
        return 'Scan Checker';
      case '5':
        return 'Scan Packing';
      case '6':
        return 'Scan Kirim';
      case '7':
        return 'Scan Retur';
      default:
        return 'Unnamed Stage';
    }
  }
}
