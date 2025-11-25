import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../common/constants/app_permissions.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/presentation/widgets/error_state_widget.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../widgets/tracker_menu_card.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ship Tracker')),
      body: const Center(child: _MenuContent()),
    );
  }
}

class _MenuContent extends StatelessWidget {
  const _MenuContent();

  @override
  Widget build(BuildContext context) {
    final visibleMenus = _getVisibleMenus(context.read<UserCubit>().user);

    if (visibleMenus.isEmpty) {
      return const ErrorStateWidget(message: 'Tidak Memiliki Hak Akses');
    }

    if (visibleMenus.length == 1) {
      final menu = visibleMenus.first;
      return TrackerMenuCard(
        size: 150,
        title: menu.title,
        route: menu.route,
        color: menu.color,
        assetName: menu.assetName,
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      padding: const .all(16),
      children: visibleMenus
          .map(
            (menu) => TrackerMenuCard(
              title: menu.title,
              route: menu.route,
              color: menu.color,
              assetName: menu.assetName,
            ),
          )
          .toList(),
    );
  }

  List<_Menu> _getVisibleMenus(UserEntity user) {
    if (user.can(AppPermissions.superAdmin)) return menus;

    return menus.where((menu) => user.can(menu.permission)).toList();
  }
}

class _Menu extends Equatable {
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

  @override
  List<Object?> get props => [title, route, assetName, permission, color];
}

const menus = <_Menu>[
  _Menu(
    title: 'Scan Resi',
    route: Routes.trackerScan,
    color: Colors.blue,
    assetName: AppImages.scanReceipt,
    permission: AppPermissions.scanShipment,
  ),
  _Menu(
    title: 'Scan Ambil Resi',
    route: Routes.trackerPickUp,
    color: Colors.brown,
    assetName: AppImages.pickUpReceipt,
    permission: AppPermissions.pickUpShipment,
  ),
  _Menu(
    title: 'Scan Checker',
    route: Routes.trackerCheck,
    color: Colors.red,
    assetName: AppImages.checkReceipt,
    permission: AppPermissions.checkShipment,
  ),
  _Menu(
    title: 'Scan Packing',
    route: Routes.trackerPack,
    color: Colors.green,
    assetName: AppImages.packReceipt,
    permission: AppPermissions.packShipment,
  ),
  _Menu(
    title: 'Scan Kirim',
    route: Routes.trackerSend,
    color: Colors.orange,
    assetName: AppImages.sendReceipt,
    permission: AppPermissions.sendShipment,
  ),
  _Menu(
    title: 'Scan Retur',
    route: Routes.trackerReturn,
    color: Colors.purple,
    assetName: AppImages.returnReceipt,
    permission: AppPermissions.returnShipment,
  ),
  _Menu(
    title: 'Barang Cancel',
    route: Routes.trackerCancel,
    color: Colors.indigo,
    assetName: AppImages.cancelReceipt,
    permission: AppPermissions.superAdmin,
  ),
];
