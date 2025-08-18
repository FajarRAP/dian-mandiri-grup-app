import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/supplier/presentation/cubit/supplier_cubit.dart';
import '../../features/tracker/presentation/cubit/shipment_cubit.dart';
import '../../features/warehouse/presentation/cubit/warehouse_cubit.dart';
import '../../service_container.dart';
import '../themes/colors.dart';
import 'constants.dart';

class ScaffoldWithBottomNavigationBar extends StatelessWidget {
  final StatefulNavigationShell child;

  const ScaffoldWithBottomNavigationBar({
    super.key,
    required this.child,
  });

  void listener<T>(BuildContext context, T state) async {
    final storage = getIt.get<FlutterSecureStorage>();
    final refresh = await storage.read(key: refreshTokenKey);

    if (refresh == null) await GoogleSignIn().signOut();
    if (!context.mounted) return;
    if (refresh == null) context.go(loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          bloc: context.read<AuthCubit>(),
          listener: listener<AuthState>,
        ),
        BlocListener<ShipmentCubit, ShipmentState>(
          bloc: context.read<ShipmentCubit>(),
          listener: listener<ShipmentState>,
        ),
        BlocListener<SupplierCubit, SupplierState>(
          bloc: context.read<SupplierCubit>(),
          listener: listener<SupplierState>,
        ),
        BlocListener<WarehouseCubit, WarehouseState>(
          bloc: context.read<WarehouseCubit>(),
          listener: listener<WarehouseState>,
        ),
      ],
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
              selectedIcon: _boxIcon(MaterialColors.onPrimary),
              tooltip: 'Beranda',
            ),
            NavigationDestination(
              icon: _personMenuIcon(MaterialColors.onSurface),
              label: 'Staff',
              selectedIcon: _personMenuIcon(MaterialColors.onPrimary),
              tooltip: 'Kelola Staf',
            ),
            NavigationDestination(
              icon: _personIcon(MaterialColors.onSurface),
              label: 'Profile',
              selectedIcon: _personIcon(MaterialColors.onPrimary),
              tooltip: 'Profil',
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
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
