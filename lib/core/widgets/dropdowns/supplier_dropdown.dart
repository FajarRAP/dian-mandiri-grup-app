import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/supplier/presentation/cubit/supplier_cubit.dart';
import '../../common/dropdown_entity.dart';
import '../dropdown_modal_item.dart';
import '../dropdown_search_modal.dart';

class SupplierDropdown extends StatefulWidget {
  const SupplierDropdown({
    super.key,
    required this.onTap,
  });

  final void Function(DropdownEntity supplier) onTap;

  @override
  State<SupplierDropdown> createState() => _SupplierDropdownState();
}

class _SupplierDropdownState extends State<SupplierDropdown> {
  late final SupplierCubit _supplierCubit;

  @override
  void initState() {
    super.initState();
    _supplierCubit = context.read<SupplierCubit>()..fetchSuppliersDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DropdownSearchModal(
        search: (keyword) =>
            _supplierCubit.fetchSuppliersDropdown(search: keyword),
        title: 'Supplier',
        child: BlocBuilder<SupplierCubit, SupplierState>(
          bloc: _supplierCubit,
          buildWhen: (previous, current) => current is FetchSuppliersDropdown,
          builder: (context, state) {
            if (state is FetchSuppliersDropdownLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchSuppliersDropdownLoaded) {
              return Flexible(
                child: ListView.separated(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => widget.onTap(state.suppliers[index]),
                    child: DropdownModalItem(
                      child: Text(state.suppliers[index].value),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: state.suppliers.length,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shrinkWrap: true,
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
