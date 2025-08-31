import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../../../main.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../cubit/shipment_cubit.dart';

class ShipmentReportListItem extends StatelessWidget {
  const ShipmentReportListItem({
    super.key,
    required this.shipmentReport,
  });

  final ShipmentReportEntity shipmentReport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final shipmentCubit = context.read<ShipmentCubit>();
    final formattedDate = dMyFormat.format(shipmentReport.date.toLocal());
    final savedFilename = '${shipmentReport.name}_$formattedDate.xlsx';

    return BlocBuilder<ShipmentCubit, ShipmentState>(
      bloc: shipmentCubit,
      builder: (context, state) {
        final file = File('$externalPath/$savedFilename');
        final isFileDownloaded = file.existsSync();

        return Card(
          color: MaterialColors.surfaceContainerLowest,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Image.asset(
                    spreadsheetIcon,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        shipmentReport.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dibuat pada: $formattedDate',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!isFileDownloaded)
                  IconButton(
                    onPressed: () async =>
                        await shipmentCubit.downloadShipmentReport(
                      shipmentReportEntity: shipmentReport,
                    ),
                    icon: state is DownloadShipmentReportLoading &&
                            state.shipmentReportId == shipmentReport.id
                        ? CircularProgressIndicator.adaptive()
                        : const Icon(Icons.download_for_offline_outlined),
                    color: CustomColors.primaryNormal,
                    tooltip: 'Unduh Laporan',
                  )
                else
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) async {
                      switch (value) {
                        case 'open':
                          await OpenFilex.open(file.path);
                          break;
                        case 'share':
                          await Share.shareXFiles(
                            <XFile>[XFile(file.path)],
                            text: 'Laporan Pengiriman: ${shipmentReport.name}',
                          );
                          break;
                      }
                    },
                    itemBuilder: (context) => <PopupMenuItem<String>>[
                      const PopupMenuItem(
                        value: 'open',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.open_in_new_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Buka'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.share_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Bagikan'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
