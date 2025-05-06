import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/widgets/primary_icon_button.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/profile_card.dart';
import '../widgets/update_name_dialog.dart';

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
              appBar: AppBar(
                title: const Text('Profile'),
              ),
              body: Center(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    UnconstrainedBox(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
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
                            builder: (context) => const UpdateNameDialog(),
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
                          context.go(loginRoute);
                        }

                        if (state is SignOutError) {
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
                        if (state is SignOutLoading) {
                          return const PrimaryIconButton(
                            icon: Icon(Icons.exit_to_app_rounded),
                            label: Text('Sign Out'),
                          );
                        }

                        return PrimaryIconButton(
                          onPressed: authCubit.signOut,
                          icon: Icon(Icons.exit_to_app_rounded),
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
