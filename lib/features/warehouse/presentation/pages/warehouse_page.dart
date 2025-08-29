import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/debouncer.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/expanded_fab/action_button.dart';
import '../../../../core/widgets/expanded_fab/expandable_fab.dart';
import '../cubit/warehouse_cubit.dart';
import '../widgets/purchase_note_item.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    final focusNode = FocusScope.of(context, createDependency: false);
    final warehouseCubit = context.read<WarehouseCubit>()..fetchPurchaseNotes();
    var column = 'created_at';
    var order = 'asc';
    String? search;

    return BlocListener<WarehouseCubit, WarehouseState>(
      listener: (context, state) {
        if (state is UpdatePurchaseNoteLoaded ||
            state is InsertPurchaseNoteFileLoaded ||
            state is InsertPurchaseNoteManualLoaded ||
            state is DeletePurchaseNoteLoaded) {
          warehouseCubit.fetchPurchaseNotes();
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: warehouseCubit.fetchPurchaseNotes,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollState) {
              if (scrollState.runtimeType == ScrollEndNotification &&
                  warehouseCubit.state is! ListPaginateLast) {
                warehouseCubit.fetchPurchaseNotesPaginate(
                  column: column,
                  order: order,
                  search: search,
                );
              }

              return false;
            },
            child: CustomScrollView(
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
                        column = params.first;
                        order = params.last;
                        warehouseCubit.fetchPurchaseNotes(
                          column: column,
                          order: order,
                          search: search,
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
                          search = value;
                          debouncer.run(() => warehouseCubit.fetchPurchaseNotes(
                              column: column, order: order, search: search));
                        },
                        onTapOutside: (event) => focusNode.unfocus(),
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
                  bloc: warehouseCubit,
                  buildWhen: (previous, current) =>
                      current is FetchPurchaseNotes,
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
                          itemBuilder: (context, index) => PurchaseNoteItem(
                            onTap: () => context.push(
                              purchaseNoteDetailRoute,
                              extra: warehouseCubit.purchaseNotes[index].id,
                            ),
                            onDelete: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  BlocConsumer<WarehouseCubit, WarehouseState>(
                                listener: (context, state) {
                                  if (state is DeletePurchaseNoteLoaded) {
                                    TopSnackbar.successSnackbar(
                                        message: state.message);
                                    context.pop();
                                    warehouseCubit.fetchPurchaseNotes();
                                  }

                                  if (state is DeletePurchaseNoteError) {
                                    TopSnackbar.dangerSnackbar(
                                        message: state.message);
                                    context.pop();
                                  }
                                },
                                builder: (context, state) {
                                  if (state is DeletePurchaseNoteLoading) {
                                    return ConfirmationDialog(
                                      actionText: 'Hapus',
                                      body:
                                          'Apakah Anda yakin ingin menghapus nota ini?',
                                      title: 'Hapus Nota',
                                    );
                                  }

                                  return ConfirmationDialog(
                                    onAction: () =>
                                        warehouseCubit.deletePurchaseNote(
                                      purchaseNoteId: warehouseCubit
                                          .purchaseNotes[index].id,
                                    ),
                                    actionText: 'Hapus',
                                    body:
                                        'Apakah Anda yakin ingin menghapus nota ini?',
                                    title: 'Hapus Nota',
                                  );
                                },
                              ),
                            ),
                            purchaseNoteSummary:
                                warehouseCubit.purchaseNotes[index],
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemCount: warehouseCubit.purchaseNotes.length,
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
      ),
    );
  }
}
