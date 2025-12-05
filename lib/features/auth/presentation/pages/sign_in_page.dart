import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/presentation/widgets/buttons/light_button.dart';
import '../../../../core/router/route_names.dart';
import '../cubit/sign_in/sign_in_cubit.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const .all(16),
        child: Center(
          child: SizedBox(
            width: .infinity,
            child: BlocConsumer<SignInCubit, SignInState>(
              listener: (context, state) {
                if (state is SignInSuccess) {
                  TopSnackbar.successSnackbar(message: state.message);
                  context
                    ..read<UserCubit>().setUser = state.user
                    ..goNamed(Routes.home);
                }

                if (state is SignInFailure) {
                  TopSnackbar.dangerSnackbar(message: state.message);
                }
              },
              builder: (context, state) {
                final onPressed = switch (state) {
                  SignInInProgress() => null,
                  _ => context.read<SignInCubit>().signIn,
                };

                return LightButton(
                  onPressed: onPressed,
                  icon: Image.asset(AppImages.google, height: 40),
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
