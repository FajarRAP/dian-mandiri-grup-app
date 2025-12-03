import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/validators.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/presentation/widgets/buttons/primary_button.dart';
import '../cubit/shipment_list/shipment_list_cubit.dart';

class CreateShipmentFromScannerDialog extends StatefulWidget {
  const CreateShipmentFromScannerDialog({super.key, required this.stage});

  final String stage;

  @override
  State<CreateShipmentFromScannerDialog> createState() =>
      _CreateShipmentFromScannerDialogState();
}

class _CreateShipmentFromScannerDialogState
    extends State<CreateShipmentFromScannerDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _receiptController;

  @override
  void initState() {
    super.initState();
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
    final textTheme = context.textTheme;

    return AlertDialog(
      contentPadding: const .all(24),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: <Widget>[
            Text(
              'Silakan Scan',
              style: textTheme.titleLarge?.copyWith(fontWeight: .w700),
              textAlign: .center,
            ),
            const Gap(8),
            RichText(
              textAlign: .center,
              text: TextSpan(
                text: 'Nama Pemindai: ',
                style: textTheme.bodyMedium,
                children: <InlineSpan>[
                  TextSpan(
                    text: context.read<UserCubit>().user.name,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            TextFormField(
              onFieldSubmitted: (_) => _onSubmit(),
              autofocus: true,
              controller: _receiptController,
              decoration: const InputDecoration(labelText: 'Hasil Scan'),
              textInputAction: .send,
              validator: inputValidator,
            ),
            const Gap(24),
            BlocConsumer<ShipmentListCubit, ShipmentListState>(
              listener: (context, state) {
                if (state.actionStatus == .success) {
                  context.pop();
                }
              },
              builder: (context, state) {
                final onPressed = switch (state.actionStatus) {
                  .inProgress => null,
                  _ => _onSubmit,
                };

                return PrimaryButton(
                  onPressed: onPressed,
                  child: const Text('Simpan'),
                );
              },
            ),
            TextButton(onPressed: context.pop, child: const Text('Batal')),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ShipmentListCubit>().createShipment(
      receiptNumber: _receiptController.text.trim(),
      stage: widget.stage,
    );
  }
}
