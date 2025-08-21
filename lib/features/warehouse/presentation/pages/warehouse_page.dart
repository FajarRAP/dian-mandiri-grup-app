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
  late final ScrollController _scrollController;
  var _column = 'created_at';
  var _order = 'asc';
  String? _search;

  @override
  void initState() {
    super.initState();
    _warehouseCubit = context.read<WarehouseCubit>()..fetchPurchaseNotes();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _scrollController = ScrollController();
    _scrollController.addListener(_onLastItem);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _warehouseCubit.fetchPurchaseNotes,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            // App Bar
            SliverAppBar(
              backgroundColor: MaterialColors.surfaceContainerLowest,
              floating: true,
              pinned: true,
              snap: true,
              title: const Text('Barang Masuk'),
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
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'created_at,asc',
                      child: Text('Tanggal Naik'),
                    ),
                    PopupMenuItem(
                      value: 'created_at,desc',
                      child: Text('Tanggal Turun'),
                    ),
                    PopupMenuItem(
                      value: 'total_item,asc',
                      child: Text('Barang Naik'),
                    ),
                    PopupMenuItem(
                      value: 'total_item,desc',
                      child: Text('Barang Turun'),
                    ),
                  ],
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(88),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    onChanged: (value) {
                      _search = value;
                      _debouncer.run(() => _warehouseCubit.fetchPurchaseNotes(
                          column: _column, order: _order, search: _search));
                    },
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      hintText: 'Cari Nota',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),

            // List
            BlocBuilder<WarehouseCubit, WarehouseState>(
              bloc: _warehouseCubit,
              buildWhen: (previous, current) => current is FetchPurchaseNotes,
              builder: (context, state) {
                if (state is FetchPurchaseNotesLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                if (state is FetchPurchaseNotesLoaded) {
                  if (state.purchaseNotes.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text('Belum ada nota'),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => context.push(
                          purchaseNoteDetailRoute,
                          extra: _warehouseCubit.purchaseNotes[index].id,
                        ),
                        child: PurchaseNoteItem(
                          purchaseNoteSummary:
                              _warehouseCubit.purchaseNotes[index],
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: _warehouseCubit.purchaseNotes.length,
                    ),
                  );
                }

                return const SliverToBoxAdapter();
              },
            ),
           
            // Widget when Pagination
            BlocBuilder<WarehouseCubit, WarehouseState>(
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

  void _onLastItem() {
    final currentPosition = _scrollController.position.pixels;
    final lastItemPosition = _scrollController.position.maxScrollExtent;
    final isLastPosition = currentPosition >= lastItemPosition;

    if (isLastPosition && _warehouseCubit.state is! ListPaginateLast) {
      _warehouseCubit.fetchPurchaseNotesPaginate(
        column: _column,
        order: _order,
        search: _search,
      );
    }
  }
}
