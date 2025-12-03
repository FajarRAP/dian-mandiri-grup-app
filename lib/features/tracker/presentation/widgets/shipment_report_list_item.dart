import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/widgets/loading_indicator.dart';
import '../../../../core/services/file_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/shipment_report_ui_model.dart';
import '../cubit/shipment_report/shipment_report_cubit.dart';

class ShipmentReportListItem extends StatelessWidget {
  const ShipmentReportListItem({super.key, required this.shipmentReport});

  final ShipmentReportUiModel shipmentReport;

  @override
  Widget build(BuildContext context) {
    const fileservice = FileService();
    final textTheme = context.textTheme;
    final entity = shipmentReport.entity;
    final isDownloading = context.select<ShipmentReportCubit, bool>(
      (cubit) => cubit.state.downloadingReportId == entity.id,
    );

    return BlocListener<ShipmentReportCubit, ShipmentReportState>(
      listenWhen: (previous, current) {
        final isDownloadFinished =
            previous.downloadingReportId != null &&
            current.downloadingReportId == null;

        return isDownloadFinished && current.message != null;
      },
      listener: (context, state) {
        if (state.failure != null) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        } else if (state.message != null) {
          TopSnackbar.successSnackbar(message: state.message!);
        }
      },
      child: Card(
        color: context.colorScheme.surfaceContainerLowest,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        child: Padding(
          padding: const .symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Image.asset(AppImages.spreadsheet, width: 24),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    Text(
                      entity.name,
                      style: textTheme.titleSmall?.copyWith(fontWeight: .w700),
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    const Gap(4),
                    Text(
                      'Dibuat pada: ${entity.date.toLocal().toDMY}',
                      style: textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              if (!shipmentReport.isDownloaded)
                IconButton(
                  onPressed: () async => await context
                      .read<ShipmentReportCubit>()
                      .downloadShipmentReport(report: entity),
                  icon: isDownloading
                      ? const LoadingIndicator()
                      : const Icon(Icons.download_for_offline_outlined),
                  color: context.colorScheme.primary,
                  tooltip: 'Unduh Laporan',
                )
              else
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) async {
                    final fullpath = await fileservice.getFullPath(
                      entity.savedFilename,
                    );
                    switch (value) {
                      case 'open':
                        await OpenFilex.open(fullpath);
                        break;
                      case 'share':
                        final shareParams = ShareParams(
                          text: 'Laporan Pengiriman: ${entity.name}',
                          files: [XFile(fullpath)],
                        );
                        await SharePlus.instance.share(shareParams);
                        break;
                    }
                  },
                  itemBuilder: (context) => <PopupMenuItem<String>>[
                    const PopupMenuItem(
                      value: 'open',
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.open_in_new_outlined, size: 20),
                          Gap(8),
                          Text('Buka'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.share_outlined, size: 20),
                          Gap(8),
                          Text('Bagikan'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
