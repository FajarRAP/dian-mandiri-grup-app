import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constants/app_constants.dart';
import '../../../common/constants/app_svgs.dart';
import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../service_container.dart';
import '../../router/route_names.dart';
import '../../services/google_sign_in_service.dart';
import '../../utils/extensions.dart';

class ScaffoldWithBottomNavigationBar extends StatelessWidget {
  const ScaffoldWithBottomNavigationBar({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: context.read<AuthCubit>(),
      listener: (context, state) async {
        if (state is RefreshTokenExpired) {
          final storage = getIt.get<FlutterSecureStorage>();
          final refresh = await storage.read(key: AppConstants.refreshTokenKey);

          if (refresh == null) await getIt<GoogleSignInService>().signOut();
          if (!context.mounted) return;
          if (refresh == null) context.goNamed(Routes.login);
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: child.goBranch,
          backgroundColor: context.colorScheme.surfaceContainerHigh,
          indicatorColor: context.colorScheme.primary,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: child.currentIndex,
          height: 70,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: _Icon.inactive(AppSvgs.box),
              label: 'Home',
              selectedIcon: _Icon.active(AppSvgs.box),
              tooltip: 'Beranda',
            ),
            NavigationDestination(
              icon: _Icon.inactive(AppSvgs.personMenu),
              label: 'Staff',
              selectedIcon: _Icon.active(AppSvgs.personMenu),
              tooltip: 'Kelola Staf',
            ),
            NavigationDestination(
              icon: _Icon.inactive(AppSvgs.person),
              label: 'Profile',
              selectedIcon: _Icon.active(AppSvgs.person),
              tooltip: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.path, required this.isActive});

  factory _Icon.active(String path) => _Icon(path: path, isActive: true);
  factory _Icon.inactive(String path) => _Icon(path: path, isActive: false);

  final String path;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter: .mode(
        isActive
            ? context.colorScheme.surfaceContainerLowest
            : context.colorScheme.onSurface,
        .srcIn,
      ),
    );
  }
}
