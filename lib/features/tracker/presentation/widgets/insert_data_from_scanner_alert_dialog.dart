import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/ship_cubit.dart';

class InsertDataFromScannerAlertDialog extends StatefulWidget {
  const InsertDataFromScannerAlertDialog({
    super.key,
    required this.audioPlayer,
    required this.stageId,
  });

  final AudioPlayer audioPlayer;

  final int stageId;

  @override
  State<InsertDataFromScannerAlertDialog> createState() =>
      _InsertDataFromScannerAlertDialogState();
}

class _InsertDataFromScannerAlertDialogState
    extends State<InsertDataFromScannerAlertDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final String name = context.read<AuthCubit>().user?.userMetadata?['name'] ??
        'Tidak Diketahui';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Silakan Scan',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Hasil Scan',
              ),
              focusNode: FocusNode(),
              validator: inputValidator,
            ),
            const SizedBox(height: 16),
            Text(
              'Nama Pemindai:',
              style: textTheme.bodyMedium,
            ),
            Text(
              name,
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await context
                  .read<ShipCubit>()
                  .insertShip(_controller.text.trim(), name, widget.stageId);
            }
          },
          child: BlocConsumer<ShipCubit, ShipState>(
            buildWhen: (previous, current) => current is InsertShip,
            listener: (context, state) async {
              if (state is InsertShipFinished) {
                context.pop();
                context.read<ShipCubit>().getShips(widget.stageId, DateTime.now());
                flushbar(context, state.message);
                await widget.audioPlayer.play(AssetSource(successSound));
              }
              if (state is InsertShipError) {
                if (!context.mounted) return;

                flushbar(context, state.message);

                switch (state.statusCode) {
                  case 400:
                    await widget.audioPlayer.play(AssetSource(skipSound));
                    break;
                  case 401:
                  case 23505:
                    await widget.audioPlayer.play(AssetSource(repeatSound));
                    break;
                }
              }
            },
            builder: (context, state) {
              if (state is InsertShipLoading) {
                return const CircularProgressIndicator();
              }
              return const Text(
                'Simpan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
