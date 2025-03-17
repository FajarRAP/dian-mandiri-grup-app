import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../cubit/auth_cubit.dart';

class UpdateNameDialog extends StatefulWidget {
  const UpdateNameDialog({super.key});

  @override
  State<UpdateNameDialog> createState() => UpdateNameDialogState();
}

class UpdateNameDialogState extends State<UpdateNameDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    _controller.text = authCubit.user.name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return AlertDialog(
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            await authCubit.updateProfile(name: _controller.text.trim());
          },
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is UpdateProfileLoaded) {
                context.pop();
                authCubit.fetchUser();
                scaffoldMessengerKey.currentState
                    ?.showSnackBar(successSnackbar(state.message));
              }
              if (state is UpdateProfileError) {
                scaffoldMessengerKey.currentState
                    ?.showSnackBar(dangerSnackbar(state.message));
              }
            },
            builder: (context, state) {
              if (state is UpdateProfileLoading) {
                return const CircularProgressIndicator();
              }

              return const Text('Selesai');
            },
          ),
        ),
      ],
      content: Form(
        key: _formKey,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Nama',
          ),
          validator: inputValidator,
        ),
      ),
      title: const Text('Silakan Isi'),
    );
  }
}
