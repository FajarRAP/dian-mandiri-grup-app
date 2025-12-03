import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/presentation/widgets/confirmation_input_dialog.dart';
import '../cubit/update_profile_cubit.dart';

class UpdateProfileDialog extends StatelessWidget {
  const UpdateProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileFailure) {
          TopSnackbar.dangerSnackbar(message: state.failure.message);
        }

        if (state is UpdateProfileSuccess) {
          TopSnackbar.successSnackbar(message: state.message);

          context
            ..pop()
            ..read<UserCubit>().fetchUser();
        }
      },
      builder: (context, state) {
        final onAction = switch (state) {
          UpdateProfileLoading() => null,
          _ => (value) => context.read<UpdateProfileCubit>().updateProfile(
            name: value,
          ),
        };
        return ConfirmationInputDialog(
          onConfirm: onAction,
          fieldBuilder: (context, controller) => TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nama Baru'),
          ),
          actionText: 'Ganti nama',
          body: 'Masukkan nama baru Anda di bawah ini.',
          title: 'Ganti Nama',
        );
      },
    );
  }
}
