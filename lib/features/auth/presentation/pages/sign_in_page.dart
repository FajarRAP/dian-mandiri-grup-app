import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../cubit/auth_cubit.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is SignInLoaded) {
                  flushbar(state.message);
                  context.go(trackerRoute);
                }

                if (state is SignInError) {
                  flushbar(state.message);
                }
              },
              builder: (context, state) {
                if (state is SignInLoading) {
                  return ElevatedButton.icon(
                    onPressed: null,
                    icon: Image.asset(googleIcon, scale: 1.5),
                    label: const Text('Masuk dengan Akun Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      fixedSize: const Size.fromHeight(56),
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }

                return ElevatedButton.icon(
                  onPressed: authCubit.signIn,
                  icon: Image.asset(googleIcon, scale: 1.5),
                  label: const Text('Masuk dengan Akun Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    fixedSize: const Size.fromHeight(56),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
