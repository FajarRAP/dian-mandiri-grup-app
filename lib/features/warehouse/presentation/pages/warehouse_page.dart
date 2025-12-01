import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/constants/app_enums.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/presentation/widgets/expandable_fab/action_button.dart';
import '../../../../core/presentation/widgets/expandable_fab/expandable_fab.dart';
import '../../../../core/presentation/widgets/pagination_listener.dart';
import '../../../../core/presentation/widgets/sliver_empty_data.dart';
import '../../../../core/presentation/widgets/sliver_loading_indicator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';
import '../cubit/purchase_note_list/purchase_note_list_cubit.dart';
import '../widgets/delete_purchase_note_dialog.dart';
import '../widgets/purchase_note_item.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  @override
  void initState() {
    super.initState();
    context.read<PurchaseNoteListCubit>().fetchPurchaseNotes();
  }

  @override
  Widget build(BuildContext context) {
    final purchaseNoteListCubit = context.read<PurchaseNoteListCubit>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: purchaseNoteListCubit.fetchPurchaseNotes,
        child: PaginationListener(
          onPaginate: purchaseNoteListCubit.fetchPurchaseNotesPaginate,
          child: CustomScrollView(
            slivers: [
              const _AppBar(),
              BlocBuilder<PurchaseNoteListCubit, PurchaseNoteListState>(
                builder: (context, state) {
                  return switch (state.status) {
                    .inProgress => const SliverLoadingIndicator(),
                    .success when (state.purchaseNotes.isEmpty) =>
                      const SliverEmptyData(),
                    .success => _SuccessWidget(
                      purchaseNotes: state.purchaseNotes,
                    ),
                    _ => const SliverToBoxAdapter(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const _FAB(),
      resizeToAvoidBottomInset: false,
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar();

  @override
  State<_AppBar> createState() => __AppBarState();
}

class __AppBarState extends State<_AppBar> {
  late final Debouncer _debouncer;
  late final PurchaseNoteListCubit _purchaseNoteListCubit;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _purchaseNoteListCubit = context.read<PurchaseNoteListCubit>();
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
          onSelected: (value) => context
              .read<PurchaseNoteListCubit>()
              .fetchPurchaseNotes(sortOption: value),
          initialValue: context.select<PurchaseNoteListCubit, SortOptions>(
            (cubit) => cubit.state.sortOptions,
          ),
          icon: const Icon(Icons.sort),
          tooltip: 'Urutkan',
          itemBuilder: (context) =>
              [...SortOptions.byDate, ...SortOptions.byTotalItems]
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
        background: Align(
          alignment: .bottomCenter,
          child: Padding(
            padding: const .all(16),
            child: TextFormField(
              onChanged: (value) => _debouncer.run(
                () => _purchaseNoteListCubit.fetchPurchaseNotes(query: value),
              ),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                hintText: 'Cari Nota',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      pinned: true,
      snap: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      title: const Text('Barang Masuk'),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.purchaseNotes});

  final List<PurchaseNoteSummaryEntity> purchaseNotes;

  @override
  Widget build(BuildContext context) {
    final purchaseNoteListCubit = context.read<PurchaseNoteListCubit>();
    return SliverPadding(
      padding: const .all(16),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => PurchaseNoteItem(
          onDelete: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: purchaseNoteListCubit,
                child: DeletePurchaseNoteDialog(
                  purchaseNoteId: purchaseNotes[index].id,
                ),
              ),
            );

            if (result == true) {
              await purchaseNoteListCubit.fetchPurchaseNotes();
            }
          },
          onTap: () => context.pushNamed(
            Routes.warehouseDetail,
            extra: purchaseNotes[index].id,
          ),
          purchaseNoteSummary: purchaseNotes[index],
        ),
        separatorBuilder: (context, index) => const Gap(12),
        itemCount: purchaseNotes.length,
      ),
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB();

  @override
  Widget build(BuildContext context) {
    return ExpandableFAB(
      distance: 100,
      children: <Widget>[
        ActionButton(
          onPressed: () =>
              context.pushNamed(Routes.warehouseAddPurchaseNoteManual),
          icon: Icons.add,
        ),
        ActionButton(
          onPressed: () =>
              context.pushNamed(Routes.warehouseAddPurchaseNoteFile),
          icon: Icons.folder,
        ),
        ActionButton(
          onPressed: () => context.pushNamed(Routes.warehouseAddShippingFee),
          icon: Icons.currency_exchange,
        ),
      ],
    );
  }
}
