import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../cubit/purchase_note_list/purchase_note_list_cubit.dart';

class DeletePurchaseNoteDialog extends StatelessWidget {
  const DeletePurchaseNoteDialog({super.key, required this.purchaseNoteId});

  final String purchaseNoteId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseNoteListCubit, PurchaseNoteListState>(
      listener: (context, state) {
        if (state.actionStatus == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
          context.pop(true);
        }
    
        if (state.actionStatus == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        }
      },
      builder: (context, state) {
        final onAction = switch (state.actionStatus) {
          .inProgress => null,
          _ => () => context.read<PurchaseNoteListCubit>().deletePurchaseNote(
            purchaseNoteId: purchaseNoteId,
          ),
        };
    
        return ConfirmationDialog(
          onAction: onAction,
          actionText: 'Hapus',
          body: 'Apakah Anda yakin ingin menghapus nota ini?',
          title: 'Hapus Nota',
        );
      },
    );
  }
}
