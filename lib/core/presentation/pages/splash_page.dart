import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constants/app_images.dart';
import '../../router/route_names.dart';
import '../cubit/app_cubit.dart';
import '../cubit/user_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      bloc: context.read<AppCubit>()..initializeApp(),
      listener: (context, state) {
        if (state is AppSuccess) {
          context
            ..read<UserCubit>().setUser = state.user
            ..goNamed(Routes.home);
        }

        if (state is NavigateToLogin) {
          context.goNamed(Routes.login);
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            alignment: .center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.app),
                fit: .contain,
              ),
              shape: .circle,
            ),
            width: 200,
          ),
        ),
      ),
    );
  }
}
