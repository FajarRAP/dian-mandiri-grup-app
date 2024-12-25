import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit..fetchUser(),
      buildWhen: (previous, current) => current is FetchUser,
      builder: (context, state) {
        if (state is FetchUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FetchUserLoaded) {
          return RefreshIndicator(
            onRefresh: authCubit.fetchUser,
            child: Scaffold(
              appBar: AppBar(title: const Text('Profile')),
              body: Center(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    UnconstrainedBox(
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[600],
                        ),
                        child: Text(
                          authCubit.user.name[0].toUpperCase(),
                          style: textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      authCubit.user.name,
                      style: textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 72),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return ProfileCard(
                          title: 'Nama',
                          body: authCubit.user.name,
                          icon: Icons.person,
                          child: IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const _UpdateProfileDialog(),
                              );
                            },
                            icon: const Icon(Icons.mode_edit_outline_rounded),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileCard(
                      body: authCubit.user.email,
                      icon: Icons.email_rounded,
                      title: 'Email',
                    ),
                    const SizedBox(height: 24),
                    BlocConsumer<AuthCubit, AuthState>(
                      buildWhen: (previous, current) => current is SignOut,
                      listenWhen: (previous, current) => current is SignOut,
                      listener: (context, state) {
                        if (state is SignOutLoaded) {
                          flushbar(state.message);
                          context.go(loginRoute);
                        }

                        if (state is SignOutError) {
                          flushbar(state.message);
                        }
                      },
                      builder: (context, state) {
                        if (state is SignOutLoading) {
                          return const MyElevatedButton(
                            onPressed: null,
                            icon: Icons.exit_to_app_rounded,
                            label: Text('Sign Out'),
                          );
                        }

                        return MyElevatedButton(
                          onPressed: authCubit.signOut,
                          icon: Icons.exit_to_app_rounded,
                          label: const Text('Sign Out'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _UpdateProfileDialog extends StatefulWidget {
  const _UpdateProfileDialog();

  @override
  State<_UpdateProfileDialog> createState() => _UpdateProfileDialogState();
}

class _UpdateProfileDialogState extends State<_UpdateProfileDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    _controller.text = authCubit.user.name;

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
                flushbar('Berhasil Ubah Nama');
                authCubit.fetchUser();
              }
              if (state is UpdateProfileError) {
                flushbar(state.message);
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
