import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/tracker/presentation/cubit/shipment_cubit.dart';
import '../../service_container.dart';
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
      ],
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: child.currentIndex,
          onTap: child.goBranch,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
