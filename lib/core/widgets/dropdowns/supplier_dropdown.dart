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
  String? _search;

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
        search: (keyword) {
          _search = keyword;
          _supplierCubit.fetchSuppliersDropdown(search: _search);
        },
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
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollState) {
                    if (scrollState.runtimeType == ScrollEndNotification &&
                        _supplierCubit.state is! ListPaginateLast) {
                      _supplierCubit.fetchSuppliersDropdownPaginate(
                          search: _search);
                    }

                    return false;
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListView.separated(
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
                      // Widget when Pagination
                      BlocBuilder<SupplierCubit, SupplierState>(
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
