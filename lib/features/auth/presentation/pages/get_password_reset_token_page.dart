import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_tracker/core/helpers/validators.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/my_elevated_button.dart';
import '../../../../core/common/snackbar.dart';
import '../cubit/auth_cubit.dart';

class GetPasswordResetTokenPage extends StatefulWidget {
  const GetPasswordResetTokenPage({super.key});

  @override
  State<GetPasswordResetTokenPage> createState() =>
      _GetPasswordResetTokenPageState();
}

class _GetPasswordResetTokenPageState extends State<GetPasswordResetTokenPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Silakan masukkan email yang telah terdaftar untuk mendapatkan kode reset',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                onChanged: (value) {
                  if (!_formKey.currentState!.validate()) return;
                },
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
            ),
            const SizedBox(height: 16),
            MyElevatedButton(
              icon: Icons.send,
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                await context
                    .read<AuthCubit>()
                    .sendPasswordResetToken(_controller.text.trim());
              },
              label: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is TokenSended) {
                    flushbar(context, state.message);
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
                    'Kirim Kode Reset',
                    style: textTheme.titleLarge?.copyWith(color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.push(resetPasswordRoute),
              child: RichText(
                text: TextSpan(
                  text: 'Klik Di Sini ',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.primary),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Jika Sudah Menerima Kode Reset',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
