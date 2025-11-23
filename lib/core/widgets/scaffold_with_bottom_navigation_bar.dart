import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../service_container.dart';
import '../common/constants.dart';
import '../services/google_sign_in_service.dart';
import '../themes/colors.dart';

class ScaffoldWithBottomNavigationBar extends StatelessWidget {
  final StatefulNavigationShell child;

  const ScaffoldWithBottomNavigationBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: context.read<AuthCubit>(),
      listener: (context, state) async {
        if (state is RefreshTokenExpired) {
          final storage = getIt.get<FlutterSecureStorage>();
          final refresh = await storage.read(key: refreshTokenKey);

          if (refresh == null) await getIt<GoogleSignInService>().signOut();
          if (!context.mounted) return;
          if (refresh == null) context.go(loginRoute);
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: child.goBranch,
          backgroundColor: CustomColors.primaryLightHover,
          indicatorColor: CustomColors.primaryNormalHover,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: child.currentIndex,
          height: 70,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: _boxIcon(MaterialColors.onSurface),
              label: 'Home',
              selectedIcon: _boxIcon(MaterialColors.surfaceContainerLowest),
              tooltip: 'Beranda',
            ),
            NavigationDestination(
              icon: _personMenuIcon(MaterialColors.onSurface),
              label: 'Staff',
              selectedIcon:
                  _personMenuIcon(MaterialColors.surfaceContainerLowest),
              tooltip: 'Kelola Staf',
            ),
            NavigationDestination(
              icon: _personIcon(MaterialColors.onSurface),
              label: 'Profile',
              selectedIcon: _personIcon(MaterialColors.surfaceContainerLowest),
              tooltip: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxIcon(Color color) {
    return SvgPicture.asset(
      boxSvg,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _personMenuIcon(Color color) {
    return SvgPicture.asset(
      personMenuSvg,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _personIcon(Color color) {
    return SvgPicture.asset(
      personSvg,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}
