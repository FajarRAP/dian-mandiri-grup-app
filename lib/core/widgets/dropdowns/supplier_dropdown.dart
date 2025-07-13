import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/supplier/presentation/cubit/supplier_cubit.dart';
import '../../common/dropdown_entity.dart';
import '../../helpers/debouncer.dart';
import '../dropdown_modal_item.dart';
import '../dropdown_search_modal.dart';

class SupplierDropdown extends StatelessWidget {
  const SupplierDropdown({
    super.key,
    required this.onTap,
  });

  final void Function(DropdownEntity supplier) onTap;

  @override
  Widget build(BuildContext context) {
    final supplierCubit = context.read<SupplierCubit>();
    final debouncer = Debouncer(delay: Duration(milliseconds: 500));

    return DropdownSearchModal(
      search: (keyword) => debouncer
          .run(() => supplierCubit.fetchSuppliersDropdown(search: keyword)),
      title: 'supplier',
      child: Expanded(
        child: BlocBuilder<SupplierCubit, SupplierState>(
          bloc: supplierCubit..fetchSuppliersDropdown(),
          buildWhen: (previous, current) => current is FetchSuppliersDropdown,
          builder: (context, state) {
            if (state is FetchSuppliersDropdownLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchSuppliersDropdownLoaded) {
              return ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => onTap(state.suppliers[index]),
                  child: DropdownModalItem(
                    child: Text(state.suppliers[index].value),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: state.suppliers.length,
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
