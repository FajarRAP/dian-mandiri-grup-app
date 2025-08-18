import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/debouncer.dart';
import '../../../../core/themes/colors.dart';
import '../../../tracker/presentation/widgets/action_button.dart';
import '../../../tracker/presentation/widgets/expandable_fab.dart';
import '../cubit/warehouse_cubit.dart';
import '../widgets/purchase_note_item.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  late final WarehouseCubit _warehouseCubit;
  late final Debouncer _debouncer;
  var _column = 'created_at';
  var _order = 'asc';
  String? _search;

  @override
  void initState() {
    super.initState();
    _warehouseCubit = context.read<WarehouseCubit>()..fetchPurchaseNotes();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              final params = value.split(',');
              _column = params.first;
              _order = params.last;
              _warehouseCubit.fetchPurchaseNotes(
                column: _column,
                order: _order,
                search: _search,
              );
            },
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan',
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'created_at,asc',
                child: const Text('Tanggal Ditambahkan Naik'),
              ),
              PopupMenuItem(
                value: 'created_at,desc',
                child: const Text('Tanggal Ditambahkan Turun'),
              ),
              PopupMenuItem(
                value: 'total_item,asc',
                child: const Text('Total Barang Naik'),
              ),
              PopupMenuItem(
                value: 'total_item,desc',
                child: const Text('Total Barang Turun'),
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
                _search = value;
                _debouncer.run(() => _warehouseCubit.fetchPurchaseNotes(
                    column: _column, order: _order, search: _search));
              },
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'Cari Nota',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        title: const Text('Barang Masuk'),
      ),
      body: RefreshIndicator(
        onRefresh: _warehouseCubit.fetchPurchaseNotes,
        displacement: 10,
        child: BlocBuilder<WarehouseCubit, WarehouseState>(
          bloc: _warehouseCubit,
          buildWhen: (previous, current) => current is FetchPurchaseNotes,
          builder: (context, state) {
            if (state is FetchPurchaseNotesLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchPurchaseNotesLoaded) {
              if (state.purchaseNotes.isEmpty) {
                return const Center(
                  child: Text('Belum ada nota'),
                );
              }

              return ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => context.push(
                    purchaseNoteDetailRoute,
                    extra: state.purchaseNotes[index].id,
                  ),
                  child: PurchaseNoteItem(
                    purchaseNoteSummary: state.purchaseNotes[index],
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: state.purchaseNotes.length,
                padding: const EdgeInsets.all(16),
              );
            }

            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: ExpandableFAB(
        distance: 100,
        children: <Widget>[
          ActionButton(
            onPressed: () => context.push(addPurchaseNoteManualRoute),
            icon: Icons.add,
          ),
          ActionButton(
            onPressed: () => context.push(addPurchaseNoteFileRoute),
            icon: Icons.folder,
          ),
          ActionButton(
            onPressed: () => context.push(addShippingFeeRoute),
            icon: Icons.currency_exchange,
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
