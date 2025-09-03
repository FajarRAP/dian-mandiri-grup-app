import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/warehouse/presentation/cubit/warehouse_cubit.dart';
import '../../common/dropdown_entity.dart';
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
  late final WarehouseCubit _warehouseCubit;
  String? _search;

  @override
  void initState() {
    super.initState();
    _warehouseCubit = context.read<WarehouseCubit>()
      ..fetchPurchaseNotesDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DropdownSearchModal(
        search: (keyword) {
          _search = keyword;
          _warehouseCubit.fetchPurchaseNotesDropdown(search: _search);
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListView.separated(
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => widget.onTap(state.purchaseNotes[index]),
                          child: DropdownModalItem(
                            child: Text(state.purchaseNotes[index].value),
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: state.purchaseNotes.length,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shrinkWrap: true,
                      ),
                      // Widget when Pagination
                      BlocBuilder<WarehouseCubit, WarehouseState>(
                        buildWhen: (previous, current) =>
                            current is ListPaginate,
                        builder: (context, state) {
                          if (state is ListPaginateLoading) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ],
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
