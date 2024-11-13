import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/my_elevated_button.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: const Text('Daftar Akun'),
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
                      obscureText: isObsecure,
                      validator: passwordValidator,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return DropdownButtonFormField(
                        onChanged: authCubit.selectRole,
                        items: const <DropdownMenuItem>[
                          DropdownMenuItem(
                            value: 0,
                            child: Text(
                              'Pilih Tugas',
                              style: TextStyle(color: Color(0xFFBDBDBD)),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Scan Resi'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Scan Ambil Resi'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('Scan Checker'),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('Scan Packing'),
                          ),
                          DropdownMenuItem(
                            value: 6,
                            child: Text('Scan Kirim'),
                          ),
                          DropdownMenuItem(
                            value: 7,
                            child: Text('Scan Retur'),
                          ),
                        ],
                        style:
                            theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                        value: authCubit.selectedRole,
                        validator: dropdownValidator,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            MyElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await authCubit.register(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                }
              },
              icon: Icons.person_add_alt_rounded,
              label: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoaded) {
                    flushbar(context, 'Berhasil Mendaftarkan Akun');
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
                    'Daftar',
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
}
