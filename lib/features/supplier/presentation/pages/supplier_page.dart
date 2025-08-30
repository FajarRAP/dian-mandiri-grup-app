import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/debouncer.dart';
import '../../../../core/themes/colors.dart';
import '../cubit/supplier_cubit.dart';
import '../widgets/supplier_item.dart';

class SupplierPage extends StatelessWidget {
  const SupplierPage({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    final supplierCubit = context.read<SupplierCubit>()..fetchSuppliers();
    final focusNode = FocusScope.of(context, createDependency: false);
    var column = 'name';
    var sort = 'asc';
    String? search;

    return Scaffold(
      body: BlocListener<SupplierCubit, SupplierState>(
        listener: (context, state) {
          if (state is InsertSupplierLoaded || state is UpdateSupplierLoaded) {
            supplierCubit.fetchSuppliers();
          }
        },
        child: RefreshIndicator(
          onRefresh: supplierCubit.fetchSuppliers,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollState) {
              if (scrollState.runtimeType == ScrollEndNotification &&
                  supplierCubit.state is! ListPaginateLast) {
                supplierCubit.fetchSuppliersPaginate(
                    column: column, sort: sort, search: search);
              }

              return false;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                // App Bar
                SliverAppBar(
                  actions: <Widget>[
                    PopupMenuButton(
                      onSelected: (value) {
                        final params = value.split(',');
                        column = params.first;
                        sort = params.last;
                        supplierCubit.fetchSuppliers(
                          column: column,
                          sort: sort,
                          search: search,
                        );
                      },
                      icon: const Icon(Icons.sort),
                      tooltip: 'Urutkan',
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                        PopupMenuItem(
                          value: 'name,asc',
                          child: const Text('Nama Naik'),
                        ),
                        PopupMenuItem(
                          value: 'name,desc',
                          child: const Text('Nama Turun'),
                        ),
                        PopupMenuItem(
                          value: 'created_at,asc',
                          child: const Text('Tanggal Ditambahkan Naik'),
                        ),
                        PopupMenuItem(
                          value: 'created_at,desc',
                          child: const Text('Tanggal Ditambahkan Turun'),
                        ),
                      ],
                    ),
                  ],
                  backgroundColor: MaterialColors.surfaceContainerLowest,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(88),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: MaterialColors.outlineVariant,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        onChanged: (value) {
                          search = value;
                          debouncer.run(() => supplierCubit.fetchSuppliers(
                              search: search, column: column, sort: sort));
                        },
                        onTapOutside: (event) => focusNode.unfocus(),
                        decoration: InputDecoration(
                          hintText: 'Cari Supplier',
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  floating: true,
                  pinned: true,
                  snap: true,
                  title: const Text('Supplier'),
                ),
                // List
                BlocBuilder<SupplierCubit, SupplierState>(
                  bloc: supplierCubit,
                  buildWhen: (previous, current) => current is FetchSuppliers,
                  builder: (context, state) {
                    if (state is FetchSuppliersLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    if (state is FetchSuppliersLoaded) {
                      if (state.suppliers.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text('Belum ada supplier'),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList.separated(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => context.push(
                              supplierDetailRoute,
                              extra: state.suppliers[index].id,
                            ),
                            child:
                                SupplierItem(supplier: state.suppliers[index]),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: state.suppliers.length,
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                // Widget when Pagination
                BlocBuilder<SupplierCubit, SupplierState>(
                  buildWhen: (previous, current) => current is ListPaginate,
                  builder: (context, state) {
                    if (state is ListPaginateLoading) {
                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(addSupplierRoute),
        child: const Icon(Icons.add),
      ),
    );
  }
}
