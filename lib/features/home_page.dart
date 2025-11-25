import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/common/constants.dart';
import '../core/helpers/helpers.dart';
import '../core/themes/colors.dart';
import 'auth/presentation/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: context.read<AuthCubit>()..fetchUser(),
      buildWhen: (previous, current) => current is FetchUser,
      builder: (context, state) {
        if (state is FetchUserLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (state is FetchUserLoaded) {
          return Scaffold(
            backgroundColor: CustomColors.primaryNormal,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Halo!',
                          style: textTheme.headlineSmall?.copyWith(
                            color: MaterialColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          context.read<AuthCubit>().user.name,
                          style: textTheme.headlineSmall?.copyWith(
                            color: MaterialColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Laporan Laba Rugi',
                          style: textTheme.titleMedium?.copyWith(
                            color: MaterialColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Total Pemasukan',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: MaterialColors.onPrimary,
                                  ),
                                ),
                                Text(
                                  10000000.toIDRCurrency,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: MaterialColors.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.white,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Total Pengeluaran',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: MaterialColors.onPrimary,
                                  ),
                                ),
                                Text(
                                  10000000.toIDRCurrency,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: MaterialColors.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MaterialColors.secondaryContainer,
                          ),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              Text(
                                100000000.toIDRCurrency,
                                style: textTheme.titleLarge?.copyWith(
                                  color: MaterialColors.onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(Laba Bersih)',
                                style: textTheme.labelSmall?.copyWith(
                                  color: MaterialColors.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        color: MaterialColors.onPrimary,
                      ),
                      padding: const EdgeInsets.all(24),
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 12 / 9,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              GridMenuItem(
                                onTap: () => context.push(warehouseRoute),
                                icon: Icons.factory_outlined,
                                title: 'Barang Mentah',
                              ),
                              const GridMenuItem(
                                icon: Icons.category_outlined,
                                title: 'Kategori Barang',
                              ),
                              const GridMenuItem(
                                icon: Icons.inventory_2_outlined,
                                title: 'Manajemen Stok',
                              ),
                              GridMenuItem(
                                onTap: () => context.push(supplierRoute),
                                icon: Icons.person_outline,
                                title: 'Supplier',
                              ),
                              const GridMenuItem(
                                icon: Icons.receipt_long_outlined,
                                title: 'Pembelian Barang',
                              ),
                              GridMenuItem(
                                onTap: () => context.push(trackerRoute),
                                icon: Icons.local_shipping_outlined,
                                title: 'Ship Tracker',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Riwayat Transaksi',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Lihat Semua',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class GridMenuItem extends StatelessWidget {
  const GridMenuItem({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
  });

  final void Function()? onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        overlayColor:
            const WidgetStatePropertyAll(MaterialColors.primaryContainer),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: CustomColors.primaryNormal),
            const SizedBox(height: 10),
            Text(
              title,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
