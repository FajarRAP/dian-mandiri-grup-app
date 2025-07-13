import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ship_tracker/core/common/dropdown_entity.dart';
import 'package:ship_tracker/core/helpers/debouncer.dart';
import 'package:ship_tracker/core/widgets/dropdown_modal_item.dart';
import 'package:ship_tracker/core/widgets/dropdown_search_modal.dart';
import 'package:ship_tracker/features/warehouse/presentation/cubit/warehouse_cubit.dart';

class PurchaseNoteDropdown extends StatelessWidget {
  const PurchaseNoteDropdown({
    super.key,
    required this.onTap,
  });

  final void Function(DropdownEntity purchaseNote) onTap;

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    final textTheme = Theme.of(context).textTheme;
    final warehouseCubit = context.read<WarehouseCubit>();

    return DropdownSearchModal(
      search: (keyword) => debouncer.run(
          () => warehouseCubit.fetchPurchaseNotesDropdown(search: keyword)),
      title: 'nota',
      child: Expanded(
        child: BlocBuilder<WarehouseCubit, WarehouseState>(
          bloc: warehouseCubit..fetchPurchaseNotesDropdown(),
          buildWhen: (previous, current) =>
              current is FetchPurchaseNotesDropdown,
          builder: (context, state) {
            if (state is FetchPurchaseNotesDropdownLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchPurchaseNotesDropdownLoaded) {
              return ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => onTap(state.purchaseNotes[index]),
                  child: DropdownModalItem(
                    child: Text(
                      state.purchaseNotes[index].value,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: state.purchaseNotes.length,
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
