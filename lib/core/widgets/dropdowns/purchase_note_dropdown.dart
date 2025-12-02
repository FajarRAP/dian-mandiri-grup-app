import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../service_container.dart';
import '../../common/dropdown_entity.dart';
import '../../presentation/cubit/dropdown_cubit.dart';
import '../../presentation/widgets/loading_indicator.dart';
import '../../presentation/widgets/pagination_listener.dart';
import '../dropdown_modal_item.dart';
import '../dropdown_search_modal.dart';

class PurchaseNoteDropdown extends StatelessWidget {
  const PurchaseNoteDropdown({super.key, required this.onTap});

  final void Function(DropdownEntity purchaseNote) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DropdownCubit>()..fetchPurchaseNotes(),
      child: Padding(
        padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: DropdownSearchModal(
          search: (keyword) =>
              context.read<DropdownCubit>().fetchPurchaseNotes(query: keyword),
          title: 'Nota',
          child: Expanded(
            child: BlocBuilder<DropdownCubit, DropdownState>(
              builder: (context, state) {
                return switch (state.status) {
                  .inProgress => const LoadingIndicator(),
                  .success => _SuccessWidget(
                    onTap: onTap,
                    purchaseNotes: state.items,
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
  const _SuccessWidget({required this.onTap, required this.purchaseNotes});

  final void Function(DropdownEntity purchaseNote) onTap;
  final List<DropdownEntity> purchaseNotes;

  @override
  Widget build(BuildContext context) {
    return PaginationListener(
      onPaginate: context.read<DropdownCubit>().fetchPurchaseNotesPaginate,
      child: ListView.separated(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => onTap(purchaseNotes[index]),
          child: DropdownModalItem(child: Text(purchaseNotes[index].value)),
        ),
        separatorBuilder: (context, index) => const Gap(12),
        itemCount: purchaseNotes.length,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
