import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/core/helpers/validators.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/my_elevated_button.dart';
import '../../../../core/common/snackbar.dart';
import '../cubit/auth_cubit.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _tokenController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObsecure = true;

  @override
  void dispose() {
    _tokenController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Silakan masukkan kode reset yang telah didapatkan dan isi sisanya',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      hintText: 'Kode Reset',
                    ),
                    validator: tokenValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 12),
                  StatefulBuilder(
                    builder: (context, setState) => TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password Baru',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => isObsecure = !isObsecure),
                          icon: isObsecure
                              ? const Icon(CupertinoIcons.eye_fill)
                              : const Icon(CupertinoIcons.eye_slash_fill),
                        ),
                      ),
                      obscureText: isObsecure,
                      validator: passwordValidator,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            MyElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                await context.read<AuthCubit>().resetPassword(
                    _tokenController.text.trim(),
                    _emailController.text.trim(),
                    _passwordController.text.trim());
              },
              icon: Icons.lock_reset_rounded,
              label: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is PasswordChanged) {
                    snackbar(context, state.message);
                    context.go(loginRoute);
                  }
                  if (state is AuthError) {
                    flushbar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return Text(
                    'Reset Password',
                    style: textTheme.titleLarge?.copyWith(color: Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validator(String title, String? value) => value!.isEmpty
      ? 'Harap isi'
      : value.length < 6
          ? '$title minimal 6 karakter'
          : null;
}
