import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/widgets/buttons/light_button.dart';
import '../cubit/auth_cubit.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const .all(16),
        child: Center(
          child: SizedBox(
            width: .infinity,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is SignInLoaded) {
                  TopSnackbar.successSnackbar(message: state.message);
                  context
                    ..read<UserCubit>().setUser = state.user
                    ..go(homeRoute);
                }

                if (state is SignInError) {
                  TopSnackbar.dangerSnackbar(message: state.message);
                }
              },
              builder: (context, state) {
                final onPressed = switch (state) {
                  SignInLoading() => null,
                  _ => authCubit.signIn,
                };

                return LightButton(
                  onPressed: onPressed,
                  icon: Image.asset(googleIcon, height: 40),
                  label: const Text('Masuk dengan Akun Google'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
