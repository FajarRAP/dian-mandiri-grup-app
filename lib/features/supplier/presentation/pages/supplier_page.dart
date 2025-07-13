import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/debouncer.dart';
import '../../../../core/themes/colors.dart';
import '../cubit/supplier_cubit.dart';
import '../widgets/supplier_item.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({
    super.key,
  });

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  late final SupplierCubit _supplierCubit;
  late final TextEditingController _searchController;
  late final Debouncer _debouncer;
  String? _column;
  String? _order;
  String? _search;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _supplierCubit = context.read<SupplierCubit>();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              final params = value.split(',');

              setState(() {
                _column = params.first;
                _order = params.last;
              });
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
              onChanged: (value) => _debouncer.run(
                () => _supplierCubit.fetchSuppliers(
                  search: value,
                  column: _column ?? 'name',
                  order: _order ?? 'asc',
                ),
              ),
              controller: _searchController,
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
        onRefresh: context.read<SupplierCubit>().fetchSuppliers,
        displacement: 10,
        child: BlocBuilder<SupplierCubit, SupplierState>(
          bloc: context.read<SupplierCubit>()
            ..fetchSuppliers(
              column: _column ?? 'name',
              order: _order ?? 'asc',
              search: _search,
            ),
          buildWhen: (previous, current) => current is FetchSuppliers,
          builder: (context, state) {
            if (state is FetchSuppliersLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchSuppliersLoaded) {
              return ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => context.push(
                    supplierDetailRoute,
                    extra: 'supplierId',
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
