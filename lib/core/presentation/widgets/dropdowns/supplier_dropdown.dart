import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../service_container.dart';
import '../../../domain/entities/dropdown_entity.dart';
import '../../cubit/dropdown_cubit.dart';
import '../loading_indicator.dart';
import '../pagination_listener.dart';
import '../dropdown_modal_item.dart';
import '../dropdown_search_modal.dart';

class SupplierDropdown extends StatelessWidget {
  const SupplierDropdown({super.key, required this.onTap});

  final void Function(DropdownEntity supplier) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DropdownCubit>()..fetchSuppliers(),
      child: Padding(
        padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: DropdownSearchModal(
          search: (keyword) =>
              context.read<DropdownCubit>().fetchSuppliers(query: keyword),
          title: 'Supplier',
          child: Expanded(
            child: BlocBuilder<DropdownCubit, DropdownState>(
              builder: (context, state) {
                return switch (state.status) {
                  .inProgress => const LoadingIndicator(),
                  .success => _SuccessWidget(
                    onTap: onTap,
                    suppliers: state.items,
                  ),
                  _ => const SizedBox(),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.onTap, required this.suppliers});

  final void Function(DropdownEntity supplier) onTap;
  final List<DropdownEntity> suppliers;

  @override
  Widget build(BuildContext context) {
    return PaginationListener(
      onPaginate: context.read<DropdownCubit>().fetchSuppliersPaginate,
      child: ListView.separated(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => onTap(suppliers[index]),
          child: DropdownModalItem(child: Text(suppliers[index].value)),
        ),
        separatorBuilder: (context, index) => const Gap(12),
        itemCount: suppliers.length,
        padding: const .symmetric(vertical: 12),
        shrinkWrap: true,
      ),
    );
  }
}
