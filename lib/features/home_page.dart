import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../core/presentation/cubit/user_cubit.dart';
import '../core/router/route_names.dart';
import '../core/utils/extensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.primary,
      body: const SafeArea(
        child: Column(
          crossAxisAlignment: .start,
          children: <Widget>[
            Gap(20),
            _Header(),
            Gap(28),
            _Statistics(),
            Gap(28),
            _Menu(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          Text(
            'Halo!',
            style: textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: .w600,
            ),
          ),
          Text(
            context.read<UserCubit>().user.name,
            style: textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Statistics extends StatelessWidget {
  const _Statistics();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          Text(
            'Laporan Laba Rugi',
            style: textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: .w600,
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  Text(
                    'Total Pemasukan',
                    style: textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    10000000.toIDRCurrency,
                    style: textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 50,
                color: context.colorScheme.onPrimary,
              ),
              Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  Text(
                    'Total Pengeluaran',
                    style: textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    10000000.toIDRCurrency,
                    style: textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          Container(
            decoration: BoxDecoration(
              borderRadius: .circular(10),
              color: context.colorScheme.surfaceContainer,
            ),
            padding: const .all(16),
            width: .infinity,
            child: Column(
              children: <Widget>[
                Text(
                  100000000.toIDRCurrency,
                  style: textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: .w600,
                  ),
                ),
                Text(
                  '(Laba Bersih)',
                  style: textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const .vertical(top: .circular(30)),
          color: context.colorScheme.onPrimary,
        ),
        padding: const .all(24),
        width: .infinity,
        child: Column(
          children: <Widget>[
            GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 12 / 9,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                _GridMenuItem(
                  onTap: () => context.pushNamed(Routes.warehouse),
                  icon: Icons.factory_outlined,
                  title: 'Barang Mentah',
                ),
                const _GridMenuItem(
                  icon: Icons.category_outlined,
                  title: 'Kategori Barang',
                ),
                const _GridMenuItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'Manajemen Stok',
                ),
                _GridMenuItem(
                  onTap: () => context.pushNamed(Routes.supplier),
                  icon: Icons.person_outline,
                  title: 'Supplier',
                ),
                const _GridMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Pembelian Barang',
                ),
                _GridMenuItem(
                  onTap: () => context.pushNamed(Routes.tracker),
                  icon: Icons.local_shipping_outlined,
                  title: 'Ship Tracker',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: <Widget>[
                Text(
                  'Riwayat Transaksi',
                  style: textTheme.labelLarge?.copyWith(fontWeight: .w500),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Lihat Semua',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: .w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GridMenuItem extends StatelessWidget {
  const _GridMenuItem({this.onTap, required this.icon, required this.title});

  final void Function()? onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(10),
        overlayColor: WidgetStatePropertyAll(
          context.colorScheme.inversePrimary,
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: <Widget>[
            Icon(icon, color: context.colorScheme.primary),
            const Gap(10),
            Text(
              title,
              style: textTheme.labelSmall?.copyWith(fontWeight: .w500),
            ),
          ],
        ),
      ),
    );
  }
}
