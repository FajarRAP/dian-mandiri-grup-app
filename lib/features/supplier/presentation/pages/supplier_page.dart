import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/constants/app_enums.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/presentation/widgets/pagination_listener.dart';
import '../../../../core/presentation/widgets/sliver_empty_data.dart';
import '../../../../core/presentation/widgets/sliver_loading_indicator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/supplier_entity.dart';
import '../cubit/supplier/new_supplier_cubit.dart';
import '../widgets/supplier_item.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewSupplierCubit>().fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: context.read<NewSupplierCubit>().fetchSuppliers,
        child: PaginationListener(
          onPaginate: context.read<NewSupplierCubit>().fetchSuppliersPaginate,
          child: CustomScrollView(
            slivers: [
              const _AppBar(),
              BlocBuilder<NewSupplierCubit, NewSupplierState>(
                builder: (context, state) {
                  return switch (state.status) {
                    .inProgress => const SliverLoadingIndicator(),
                    .success when (state.suppliers.isEmpty) =>
                      const SliverEmptyData(),
                    .success => _SuccessWidget(suppliers: state.suppliers),
                    _ => const SliverToBoxAdapter(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(
          Routes.supplierAdd,
          extra: context.read<NewSupplierCubit>(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar();

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  late final Debouncer _debouncer;
  late final NewSupplierCubit _supplierCubit;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _supplierCubit = context.read<NewSupplierCubit>();
  }

  @override
  void dispose() {
    _debouncer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: <Widget>[
        PopupMenuButton<SortOptions>(
          onSelected: (value) =>
              _supplierCubit.fetchSuppliers(sortOption: value),
          initialValue: context.select<NewSupplierCubit, SortOptions>(
            (cubit) => cubit.state.sortOptions,
          ),
          icon: const Icon(Icons.sort),
          tooltip: 'Urutkan',
          itemBuilder: (context) => SortOptions.all
              .map(
                (option) => PopupMenuItem<SortOptions>(
                  value: option,
                  child: Text(option.label),
                ),
              )
              .toList(),
        ),
      ],
      backgroundColor: context.colorScheme.surfaceContainerLow,
      expandedHeight: kToolbarHeight + kSpaceBarHeight,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          alignment: .bottomCenter,
          padding: const .all(16),

          child: TextFormField(
            onChanged: (value) => _debouncer.run(
              () => _supplierCubit.fetchSuppliers(query: value),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText: 'Cari Supplier',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      pinned: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      snap: true,
      title: const Text('Supplier'),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.suppliers});

  final List<SupplierEntity> suppliers;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .all(16),
      sliver: SliverList.separated(
        itemBuilder: (context, index) =>
            SupplierItem(supplier: suppliers[index]),
        separatorBuilder: (context, index) => const Gap(8),
        itemCount: suppliers.length,
      ),
    );
  }
}
