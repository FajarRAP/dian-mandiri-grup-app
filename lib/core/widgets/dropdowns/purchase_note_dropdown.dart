import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/warehouse/presentation/cubit/warehouse_cubit.dart';
import '../../common/dropdown_entity.dart';
import '../../helpers/debouncer.dart';
import '../dropdown_modal_item.dart';
import '../dropdown_search_modal.dart';

class PurchaseNoteDropdown extends StatefulWidget {
  const PurchaseNoteDropdown({
    super.key,
    required this.onTap,
  });

  final void Function(DropdownEntity purchaseNote) onTap;

  @override
  State<PurchaseNoteDropdown> createState() => _PurchaseNoteDropdownState();
}

class _PurchaseNoteDropdownState extends State<PurchaseNoteDropdown> {
  late final Debouncer _debouncer;
  late final WarehouseCubit _warehouseCubit;
  String? _search;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _warehouseCubit = context.read<WarehouseCubit>()
      ..fetchPurchaseNotesDropdown();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DropdownSearchModal(
        search: (keyword) {
          _search = keyword;
          _debouncer.run(() =>
              _warehouseCubit.fetchPurchaseNotesDropdown(search: _search));
        },
        title: 'Nota',
        child: BlocBuilder<WarehouseCubit, WarehouseState>(
          bloc: _warehouseCubit,
          buildWhen: (previous, current) =>
              current is FetchPurchaseNotesDropdown,
          builder: (context, state) {
            if (state is FetchPurchaseNotesDropdownLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchPurchaseNotesDropdownLoaded) {
              return Flexible(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollState) {
                    if (scrollState.runtimeType == ScrollEndNotification &&
                        _warehouseCubit.state is! ListPaginateLast) {
                      _warehouseCubit.fetchPurchaseNotesDropdownPaginate(
                          search: _search);
                    }

                    return false;
                  },
                  child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => widget
                          .onTap(_warehouseCubit.purchaseNotesDropdown[index]),
                      child: DropdownModalItem(
                        child: Text(
                          _warehouseCubit.purchaseNotesDropdown[index].value,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: _warehouseCubit.purchaseNotesDropdown.length,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shrinkWrap: true,
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
