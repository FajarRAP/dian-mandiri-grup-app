import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/widgets/alert_dialog_snackbar_wrapper.dart';

import '../../../../core/helpers/validators.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/shipment_cubit.dart';

class InsertDataFromScannerAlertDialog extends StatefulWidget {
  const InsertDataFromScannerAlertDialog({
    super.key,
    required this.stage,
  });

  final String stage;

  @override
  State<InsertDataFromScannerAlertDialog> createState() =>
      _InsertDataFromScannerAlertDialogState();
}

class _InsertDataFromScannerAlertDialogState
    extends State<InsertDataFromScannerAlertDialog> {
  final _receiptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _receiptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final authCubit = context.read<AuthCubit>();
    final textTheme = Theme.of(context).textTheme;

    return AlertDialogSnackbarWrapper(
      dialog: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Silakan Scan',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nomor Resi:',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              TextFormField(
                autofocus: true,
                controller: _receiptController,
                decoration: const InputDecoration(hintText: 'Hasil Scan'),
                focusNode: FocusNode(),
                validator: inputValidator,
              ),
              const SizedBox(height: 16),
              Text(
                'Nama Pemindai:',
                style: textTheme.bodyMedium,
              ),
              Text(
                authCubit.user.name,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              await shipmentCubit.insertShipment(
                  receiptNumber: _receiptController.text.trim(),
                  stage: widget.stage);
            },
            child: BlocConsumer<ShipmentCubit, ShipmentState>(
              buildWhen: (previous, current) => current is InsertShipment,
              listenWhen: (previous, current) => current is InsertShipment,
              listener: (context, state) async {
                if (state is InsertShipmentLoaded) {
                  context.pop();
                }

                if (state is InsertShipmentError) {
                  final audioPlayer = AudioPlayer();

                  ScaffoldMessenger.of(context)
                      .showSnackBar(dangerSnackbar(state.failure.message));

                  switch (state.failure.statusCode) {
                    case 422:
                      await audioPlayer.play(AssetSource(repeatSound));
                      break;
                    case 423:
                      await audioPlayer.play(AssetSource(skipSound));
                      break;
                  }
                }
              },
              builder: (context, state) {
                if (state is InsertShipmentLoading) {
                  return const CircularProgressIndicator();
                }

                return const Text(
                  'Simpan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
