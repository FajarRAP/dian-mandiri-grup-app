import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/widgets/light_icon_button.dart';
import '../cubit/auth_cubit.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is SignInLoaded) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  successSnackbar(
                    state.message,
                    EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.sizeOf(context).height - 175,
                    ),
                  ),
                );
                context.go(trackerRoute);
              }

              if (state is SignInError) {
                scaffoldMessengerKey.currentState?.showSnackBar(
                  dangerSnackbar(
                    state.message,
                    EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.sizeOf(context).height - 175,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SignInLoading) {
                return LightIconButton(
                  icon: Image.asset(googleIcon),
                  label: const Text('Masuk dengan Akun Google'),
                );
              }

              return LightIconButton(
                onPressed: authCubit.signIn,
                icon: Image.asset(googleIcon),
                label: const Text('Masuk dengan Akun Google'),
              );
            },
          ),
        ),
      ),
    );
  }
}
