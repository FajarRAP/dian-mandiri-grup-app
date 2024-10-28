import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ship_tracker/core/common/constants.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/tracker/presentation/widgets/insert_data_from_camera_alert_dialog.dart';
import '../../features/tracker/presentation/widgets/insert_data_from_scanner_alert_dialog.dart';
import '../common/snackbar.dart';

Future<void> onTapScan(
  BuildContext context,
  int stageId,
  ScanType scanType,
) async {
  final String? name = context.read<AuthCubit>().user?.userMetadata?['name'];

  if (name == null) {
    return flushbar(context, 'Nama belum diisi, silakan isi di bagian profile');
  }

  if (scanType == ScanType.camera) {
    final receiptCamera = await BarcodeScanner.scan();

    if (!context.mounted || receiptCamera.rawContent.isEmpty) return;

    await showDialog(
      context: context,
      builder: (context) => InsertDataFromCameraAlertDialog(
        audioPlayer: AudioPlayer(),
        receipt: receiptCamera.rawContent,
        stageId: stageId,
      ),
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) => InsertDataFromScannerAlertDialog(
        audioPlayer: AudioPlayer(),
        stageId: stageId,
      ),
    );
  }
}
