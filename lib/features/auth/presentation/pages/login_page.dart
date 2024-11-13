import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/core/helpers/validators.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/my_elevated_button.dart';
import '../../../../core/common/snackbar.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObsecure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                      obscureText: isObsecure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => isObsecure = !isObsecure),
                          icon: isObsecure
                              ? const Icon(CupertinoIcons.eye_fill)
                              : const Icon(CupertinoIcons.eye_slash_fill),
                        ),
                      ),
                      validator: inputValidator,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => context.push(getTokenResetPasswordRoute),
                child: RichText(
                  text: TextSpan(
                    text: 'Lupa Password? ',
                    style: theme.textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Klik Di Sini',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            MyElevatedButton(
              icon: Icons.login,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await authCubit.login(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                }
              },
              label: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoaded) {
                    snackbar(context, 'Berhasil Login');
                    context.go(trackerRoute);
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
                    'Login',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(color: Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validator(String? value) =>
      value!.trim().isEmpty ? 'Harap Isi' : null;
}
