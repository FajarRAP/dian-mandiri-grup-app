import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/presentation/widgets/confirmation_input_dialog.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/create_shipment/create_shipment_cubit.dart';

class CreateShipmentFromScannerDialog extends StatelessWidget {
  const CreateShipmentFromScannerDialog({super.key, required this.stage});

  final String stage;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    void onSubmit(String value) {
      context.read<CreateShipmentCubit>().createShipment(
        receiptNumber: value.trim(),
        stage: stage,
      );
    }

    return BlocConsumer<CreateShipmentCubit, CreateShipmentState>(
      listener: (context, state) {
        if (state.status == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
          context.pop(true);
        }

        if (state.status == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        }
      },
      builder: (context, state) {
        final onConfirm = switch (state.status) {
          .inProgress => null,
          _ => onSubmit,
        };

        return ConfirmationInputDialog(
          onConfirm: onConfirm,
          fieldBuilder: (context, controller) => TextFormField(
            onFieldSubmitted: onSubmit,
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(labelText: 'Hasil Scan'),
            textInputAction: .send,
            validator: Validator.inputValidator,
          ),
          actionText: 'Simpan',
          bodyContent: RichText(
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
          title: 'Silakan Scan',
        );
      },
    );
  }
}
