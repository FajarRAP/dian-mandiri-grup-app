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
    final supplierCubit = context.read<SupplierCubit>();
    var column = 'name';
    var order = 'asc';
    String? search;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              final params = value.split(',');
              column = params.first;
              order = params.last;
              supplierCubit.fetchSuppliers(
                column: column,
                order: order,
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
        backgroundColor: MaterialColors.onPrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              onChanged: (value) {
                search = value;
                debouncer.run(
                  () => supplierCubit.fetchSuppliers(
                    search: search,
                    column: column,
                    order: order,
                  ),
                );
              },
              decoration: InputDecoration(
                hintText: 'Cari Supplier',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        title: const Text('Supplier'),
      ),
      body: RefreshIndicator(
        onRefresh: supplierCubit.fetchSuppliers,
        displacement: 10,
        child: BlocBuilder<SupplierCubit, SupplierState>(
          bloc: supplierCubit
            ..fetchSuppliers(
              column: column,
              order: order,
              search: search,
            ),
          buildWhen: (previous, current) => current is FetchSuppliers,
          builder: (context, state) {
            if (state is FetchSuppliersLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchSuppliersLoaded) {
              if (state.suppliers.isEmpty) {
                return const Center(
                  child: Text('Belum ada supplier'),
                );
              }

              return ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => context.push(
                    supplierDetailRoute,
                    extra: state.suppliers[index].id,
                  ),
                  child: SupplierItem(supplier: state.suppliers[index]),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemCount: state.suppliers.length,
                padding: const EdgeInsets.all(16),
              );
            }

            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(addSupplierRoute),
        child: const Icon(Icons.add),
      ),
    );
  }
}
