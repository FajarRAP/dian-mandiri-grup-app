import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/widgets/confirmation_input_dialog.dart';
import '../cubit/purchase_note_cost/purchase_note_cost_cubit.dart';

class UpdateReturnCostDialog extends StatelessWidget {
  const UpdateReturnCostDialog({super.key, required this.purchaseNoteId});

  final String purchaseNoteId;

  @override
  Widget build(BuildContext context) {
    final purchaseNoteCostCubit = context.read<PurchaseNoteCostCubit>();

    return BlocConsumer<PurchaseNoteCostCubit, PurchaseNoteCostState>(
      listener: (context, state) {
        if (state.status == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
          context.pop(state.updatedReturnCost);
        }

        if (state.status == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        }
      },
      builder: (context, state) {
        final onConfirm = switch (state.status) {
          .inProgress => null,
          _ =>
            (String value) async =>
                await purchaseNoteCostCubit.updateReturnCost(
                  purchaseNoteId: purchaseNoteId,
                  returnCost: int.parse(value),
                ),
        };
        return ConfirmationInputDialog(
          fieldBuilder: (context, controller) => TextFormField(
            onChanged: (value) =>
                purchaseNoteCostCubit.updatedReturnCost = int.tryParse(value),
            onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nominal Refund',
              prefixText: 'Rp. ',
            ),

            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: .number,
            textInputAction: .send,
          ),
          onConfirm: onConfirm,
          actionText: 'Ya',
          body: 'Masukkan nominal pengembalian uang',
          title: 'Refund',
        );
      },
    );
  }
}
