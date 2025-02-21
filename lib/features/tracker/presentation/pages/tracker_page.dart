import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/constants.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/home_menu_card.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ship Tracker')),
      body: Center(
        child: BlocBuilder<AuthCubit, AuthState>(
          bloc: authCubit..fetchUserFromStorage(),
          buildWhen: (previous, current) => current is FetchUser,
          builder: (context, state) {
            if (state is FetchUserLoading) {
              return const CircularProgressIndicator();
            }

            final permissions =
                authCubit.user.permissions.map((e) => e).toList();
            final isSinglePermission = authCubit.user.permissions.length == 1;
            final isSuperAdmin =
                authCubit.user.permissions.contains(superAdminPermission);
            return GridView.count(
              childAspectRatio: isSinglePermission && !isSuperAdmin ? 2 : 1,
              crossAxisCount: isSinglePermission && !isSuperAdmin ? 1 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: _buildMenuCard(permissions, menus),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildMenuCard(List<String> permissions, List<_Menu> menus) {
    if (permissions.contains(superAdminPermission)) return _buildAdminPage();
    if (permissions.isEmpty || menus.isEmpty) return <Widget>[];

    final config = menus.first;
    final currentPermission = config.permission;

    if (permissions.contains(currentPermission)) {
      permissions.remove(currentPermission);
      return [
        HomeMenuCard(
          title: config.title,
          route: config.route,
          color: config.color,
          assetName: config.assetName,
        ),
        ..._buildMenuCard(permissions, menus.sublist(1)),
      ];
    }

    return _buildMenuCard(permissions, menus.sublist(1));
  }

  List<Widget> _buildAdminPage() {
    return <Widget>[
      HomeMenuCard(
        title: 'Scan Resi',
        route: scanReceiptRoute,
        color: Colors.blue,
        assetName: scanReceiptIcon,
      ),
      HomeMenuCard(
        title: 'Scan Ambil Barang',
        route: pickUpReceiptRoute,
        color: Colors.brown,
        assetName: pickUpReceiptIcon,
      ),
      HomeMenuCard(
        title: 'Scan Checker',
        route: checkReceiptRoute,
        color: Colors.red,
        assetName: checkReceiptIcon,
      ),
      HomeMenuCard(
        title: 'Scan Packing',
        route: packReceiptRoute,
        color: Colors.green,
        assetName: packReceiptIcon,
      ),
      HomeMenuCard(
        title: 'Scan Kirim',
        route: sendReceiptRoute,
        color: Colors.orange,
        assetName: sendReceiptIcon,
      ),
      HomeMenuCard(
        title: 'Scan Retur',
        route: returnReceiptRoute,
        color: Colors.purple,
        assetName: returnReceiptIcon,
      ),
      HomeMenuCard(
        title: 'Laporan',
        route: reportRoute,
        color: Colors.teal,
        assetName: reportReceiptIcon,
      ),
      HomeMenuCard(
        title: 'Status Resi',
        route: receiptStatusRoute,
        color: Colors.indigo,
        assetName: checkReceiptStatusIcon,
      ),
    ];
  }
}

class _Menu {
  const _Menu({
    required this.title,
    required this.route,
    required this.assetName,
    required this.permission,
    required this.color,
  });

  final String title;
  final String route;
  final String assetName;
  final String permission;
  final MaterialColor color;
}

const menus = <_Menu>[
  _Menu(
    title: 'Scan Resi',
    route: scanReceiptRoute,
    color: Colors.blue,
    assetName: scanReceiptIcon,
    permission: scanPermission,
  ),
  _Menu(
    title: 'Scan Ambil Resi',
    route: pickUpReceiptRoute,
    color: Colors.brown,
    assetName: pickUpReceiptIcon,
    permission: pickUpPermission,
  ),
  _Menu(
    title: 'Scan Checker',
    route: checkReceiptRoute,
    color: Colors.red,
    assetName: checkReceiptIcon,
    permission: checkPermission,
  ),
  _Menu(
    title: 'Scan Packing',
    route: packReceiptRoute,
    color: Colors.green,
    assetName: packReceiptIcon,
    permission: packPermission,
  ),
  _Menu(
    title: 'Scan Kirim',
    route: sendReceiptRoute,
    color: Colors.orange,
    assetName: sendReceiptIcon,
    permission: sendPermission,
  ),
  _Menu(
    title: 'Scan Retur',
    route: returnReceiptRoute,
    color: Colors.purple,
    assetName: returnReceiptIcon,
    permission: returnPermission,
  ),
];
