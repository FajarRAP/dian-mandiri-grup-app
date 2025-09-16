import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/constants.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/tracker_menu_card.dart';

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
              return const CircularProgressIndicator.adaptive();
            }

            final permissions = authCubit.user.permissions;
            final isSinglePermission = permissions.length == 1;
            final isSuperAdmin = permissions.contains(superAdminPermission);

            if (isSinglePermission && !isSuperAdmin) {
              final singleMenu =
                  menus.firstWhere((e) => e.permission == permissions.first);
              return TrackerMenuCard(
                size: 150,
                title: singleMenu.title,
                route: singleMenu.route,
                color: singleMenu.color,
                assetName: singleMenu.assetName,
              );
            }

            return GridView.count(
              childAspectRatio: isSinglePermission && !isSuperAdmin ? 2 : 1,
              crossAxisCount: isSinglePermission && !isSuperAdmin ? 1 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
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
      return <Widget>[
        TrackerMenuCard(
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
      TrackerMenuCard(
        title: 'Scan Resi',
        route: scanReceiptRoute,
        color: Colors.blue,
        assetName: scanReceiptIcon,
      ),
      TrackerMenuCard(
        title: 'Scan Ambil Barang',
        route: pickUpReceiptRoute,
        color: Colors.brown,
        assetName: pickUpReceiptIcon,
      ),
      TrackerMenuCard(
        title: 'Scan Checker',
        route: checkReceiptRoute,
        color: Colors.red,
        assetName: checkReceiptIcon,
      ),
      TrackerMenuCard(
        title: 'Scan Packing',
        route: packReceiptRoute,
        color: Colors.green,
        assetName: packReceiptIcon,
      ),
      TrackerMenuCard(
        title: 'Scan Kirim',
        route: sendReceiptRoute,
        color: Colors.orange,
        assetName: sendReceiptIcon,
      ),
      TrackerMenuCard(
        title: 'Scan Retur',
        route: returnReceiptRoute,
        color: Colors.purple,
        assetName: returnReceiptIcon,
      ),
      TrackerMenuCard(
        title: 'Barang Cancel',
        route: cancelReceiptRoute,
        color: Colors.deepOrange,
        assetName: cancelReceiptIcon,
      ),
      TrackerMenuCard(
        title: 'Laporan',
        route: reportRoute,
        color: Colors.teal,
        assetName: reportReceiptIcon,
      ),
      TrackerMenuCard(
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
  _Menu(
    title: 'Barang Cancel',
    route: cancelReceiptRoute,
    color: Colors.indigo,
    assetName: cancelReceiptIcon,
    permission: superAdminPermission,
  )
];
