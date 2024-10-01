import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/home_menu_card.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          snackbar(context, state.message);
          context.go(loginRoute);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ship Tracker'),
        ),
        body: Center(
          child: _buildTrackerPage(
            context.read<AuthCubit>().user?.userMetadata?['role'],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackerPage(int? role) {
    switch (role) {
      case 2:
        return const HomeMenuCard(
          title: 'Scan Resi',
          route: scanReceiptRoute,
          color: Colors.blue,
          assetName: scanReceiptIcon,
          size: 200,
        );
      case 3:
        return const HomeMenuCard(
          title: 'Scan Ambil Resi',
          route: pickUpReceiptRoute,
          color: Colors.brown,
          assetName: pickUpReceiptIcon,
          size: 200,
        );
      case 4:
        return const HomeMenuCard(
          title: 'Scan Checker',
          route: checkReceiptRoute,
          color: Colors.red,
          assetName: checkReceiptIcon,
          size: 200,
        );
      case 5:
        return const HomeMenuCard(
          title: 'Scan Packing',
          route: packReceiptRoute,
          color: Colors.green,
          assetName: packReceiptIcon,
          size: 200,
        );
      case 6:
        return const HomeMenuCard(
          title: 'Scan Kirim',
          route: sendReceiptRoute,
          color: Colors.orange,
          assetName: sendReceiptIcon,
          size: 200,
        );
      case 7:
        return const HomeMenuCard(
          title: 'Scan Retur',
          route: returnReceiptRoute,
          color: Colors.purple,
          assetName: returnReceiptIcon,
          size: 200,
        );
      case 8:
        return const MyGridViewCount(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomeMenuCard(
              title: 'Scan Ambil Resi',
              route: pickUpReceiptRoute,
              color: Colors.brown,
              assetName: pickUpReceiptIcon,
            ),
            HomeMenuCard(
              title: 'Scan Packing',
              route: packReceiptRoute,
              color: Colors.green,
              assetName: packReceiptIcon,
            )
          ],
        );
      case 9:
        return const MyGridViewCount(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
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
            )
          ],
        );
      default:
        return _buildAdminPage();
    }
  }

  Widget _buildAdminPage() {
    return const MyGridViewCount(
      children: <Widget>[
        HomeMenuCard(
          title: 'Scan Resi',
          route: scanReceiptRoute,
          color: Colors.blue,
          assetName: scanReceiptIcon,
        ),
        HomeMenuCard(
          title: 'Scan Ambil Resi',
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
      ],
    );
  }
}

class MyGridViewCount extends StatelessWidget {
  const MyGridViewCount({
    super.key,
    required this.children,
    this.physics,
  });

  final List<Widget> children;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      physics: physics,
      shrinkWrap: true,
      children: children,
    );
  }
}
