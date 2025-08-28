import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/widgets/confirmation_input_dialog.dart';
import '../../../../core/widgets/primary_icon_button.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocConsumer<AuthCubit, AuthState>(
      bloc: authCubit..fetchUser(),
      buildWhen: (previous, current) => current is FetchUser,
      listener: (context, state) {
        if (state is UpdateProfileLoaded) {
          authCubit.fetchUser();
        }
      },
      builder: (context, state) {
        if (state is FetchUserLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (state is FetchUserLoaded) {
          return RefreshIndicator(
            onRefresh: authCubit.fetchUser,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
              ),
              body: Center(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    UnconstrainedBox(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          shape: BoxShape.circle,
                        ),
                        height: 100,
                        width: 100,
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
                      builder: (context, state) => ProfileCard(
                        body: authCubit.user.name,
                        icon: Icons.person,
                        title: 'Nama',
                        child: IconButton(
                          onPressed: () => showDialog(
                            builder: (context) =>
                                BlocConsumer<AuthCubit, AuthState>(
                              buildWhen: (previous, current) =>
                                  current is UpdateProfile,
                              listenWhen: (previous, current) =>
                                  current is UpdateProfile,
                              listener: (context, state) {
                                if (state is UpdateProfileError) {
                                  TopSnackbar.dangerSnackbar(
                                      message: state.message);
                                }

                                if (state is UpdateProfileLoaded) {
                                  TopSnackbar.successSnackbar(
                                      message: state.message);
                                  context.pop();
                                }
                              },
                              builder: (context, state) {
                                if (state is UpdateProfileLoading) {
                                  return ConfirmationInputDialog(
                                    actionText: 'Ganti nama',
                                    body:
                                        'Masukkan nama baru Anda di bawah ini.',
                                    decoration: const InputDecoration(
                                      labelText: 'Nama Baru',
                                    ),
                                    title: 'Ganti Nama',
                                  );
                                }

                                return ConfirmationInputDialog(
                                  onAction: (value) =>
                                      authCubit.updateProfile(name: value),
                                  actionText: 'Ganti nama',
                                  body: 'Masukkan nama baru Anda di bawah ini.',
                                  decoration: const InputDecoration(
                                    labelText: 'Nama Baru',
                                  ),
                                  title: 'Ganti Nama',
                                );
                              },
                            ),
                            context: context,
                          ),
                          icon: const Icon(Icons.mode_edit_outline_rounded),
                        ),
                      ),
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
                          TopSnackbar.successSnackbar(message: state.message);
                          context.go(loginRoute);
                        }

                        if (state is SignOutError) {
                          TopSnackbar.dangerSnackbar(message: state.message);
                        }
                      },
                      builder: (context, state) {
                        if (state is SignOutLoading) {
                          return const PrimaryIconButton(
                            icon: Icon(Icons.exit_to_app_rounded),
                            label: Text('Sign Out'),
                          );
                        }

                        return PrimaryIconButton(
                          onPressed: authCubit.signOut,
                          icon: const Icon(Icons.exit_to_app_rounded),
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
