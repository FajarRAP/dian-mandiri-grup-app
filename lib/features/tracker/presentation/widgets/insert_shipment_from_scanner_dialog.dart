import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/shipment_cubit.dart';

class InsertShipmentFromScannerDialog extends StatefulWidget {
  const InsertShipmentFromScannerDialog({
    super.key,
    required this.stage,
  });

  final String stage;

  @override
  State<InsertShipmentFromScannerDialog> createState() =>
      _InsertDataFromScannerAlertDialogState();
}

class _InsertDataFromScannerAlertDialogState
    extends State<InsertShipmentFromScannerDialog> {
  late final AuthCubit _authCubit;
  late final ShipmentCubit _shipmentCubit;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _receiptController;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _shipmentCubit = context.read<ShipmentCubit>();
    _formKey = GlobalKey<FormState>();
    _receiptController = TextEditingController();
  }

  @override
  void dispose() {
    _receiptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Silakan Scan',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Nama Pemindai: ',
                style: textTheme.bodyMedium,
                children: <InlineSpan>[
                  TextSpan(
                    text: _authCubit.user.name,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              onFieldSubmitted: (value) {
                if (!_formKey.currentState!.validate()) return;

                _shipmentCubit.insertShipment(
                    receiptNumber: value, stage: widget.stage);
              },
              autofocus: true,
              controller: _receiptController,
              decoration: const InputDecoration(
                labelText: 'Hasil Scan',
              ),
              validator: inputValidator,
              textInputAction: TextInputAction.send,
            ),
            const SizedBox(height: 24),
            BlocConsumer<ShipmentCubit, ShipmentState>(
              bloc: _shipmentCubit,
              buildWhen: (previous, current) => current is InsertShipment,
              listener: (context, state) {
                if (state is InsertShipmentLoaded) {
                  context.pop();
                }
              },
              builder: (context, state) {
                final onPressed = switch (state) {
                  InsertShipmentLoading() => null,
                  _ => () {
                      if (!_formKey.currentState!.validate()) return;

                      _shipmentCubit.insertShipment(
                          receiptNumber: _receiptController.text.trim(),
                          stage: widget.stage);
                    },
                };

                return PrimaryButton(
                  onPressed: onPressed,
                  child: const Text('Simpan'),
                );
              },
            ),
            TextButton(
              onPressed: context.pop,
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}
