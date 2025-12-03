import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/presentation/widgets/error_state_widget.dart';
import '../../../../core/presentation/widgets/loading_indicator.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/presentation/widgets/buttons/primary_button.dart';
import '../../../../service_container.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/update_profile_cubit.dart';
import '../widgets/profile_card.dart';
import '../widgets/update_profile_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return switch (state.status) {
          UserStatus.inProgress => const LoadingIndicator(),
          UserStatus.success => _SuccessWidget(user: state.user!),
          UserStatus.failure => ErrorStateWidget(
            onRetry: context.read<UserCubit>().fetchUser,
            message: state.failure?.message,
          ),
          _ => const SizedBox(),
        };
      },
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<UserCubit>();

    return RefreshIndicator(
      onRefresh: userCubit.fetchUser,
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: ListView(
            padding: const .all(16),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: context.colorScheme.secondary,
                  shape: .circle,
                ),
                height: 100,
                width: 100,
                child: Text(
                  user.initials,
                  style: context.textTheme.displayLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
              const Gap(12),
              Text(
                user.name,
                style: context.textTheme.headlineMedium,
                textAlign: .center,
              ),
              const Gap(72),
              ProfileCard(
                body: user.name,
                icon: Icons.person,
                title: 'Nama',
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => BlocProvider(
                      create: (context) => getIt<UpdateProfileCubit>(),
                      child: const UpdateProfileDialog(),
                    ),
                  ),
                  icon: const Icon(Icons.mode_edit_outline_rounded),
                ),
              ),
              const Gap(12),
              ProfileCard(
                body: user.email,
                icon: Icons.email_rounded,
                title: 'Email',
              ),
              const Gap(24),
              BlocConsumer<AuthCubit, AuthState>(
                buildWhen: (previous, current) => current is SignOut,
                listenWhen: (previous, current) => current is SignOut,
                listener: (context, state) {
                  if (state is SignOutLoaded) {
                    TopSnackbar.successSnackbar(message: state.message);

                    context
                      ..read<UserCubit>().clearUser()
                      ..go(loginRoute);
                  }

                  if (state is SignOutError) {
                    TopSnackbar.dangerSnackbar(message: state.message);
                  }
                },
                builder: (context, state) {
                  final onPressed = switch (state) {
                    SignOutLoading() => null,
                    _ => context.read<AuthCubit>().signOut,
                  };

                  return PrimaryButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.exit_to_app_rounded),
                    child: const Text('Sign Out'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
