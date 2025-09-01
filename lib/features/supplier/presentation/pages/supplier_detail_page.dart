import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/shadows.dart';
import '../../../../core/themes/colors.dart';
import '../cubit/supplier_cubit.dart';

class SupplierDetailPage extends StatelessWidget {
  const SupplierDetailPage({
    super.key,
    required this.supplierId,
  });

  final String supplierId;

  @override
  Widget build(BuildContext context) {
    final supplierCubit = context.read<SupplierCubit>();
    final focusNode = FocusScope.of(context, createDependency: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Supplier'),
      ),
      body: BlocBuilder<SupplierCubit, SupplierState>(
        bloc: supplierCubit..fetchSupplier(supplierId: supplierId),
        buildWhen: (previous, current) => current is FetchSupplier,
        builder: (context, state) {
          if (state is FetchSupplierLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is FetchSupplierLoaded) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: cardBoxShadow,
                  color: MaterialColors.onPrimary,
                ),
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: AssetImage(appIcon),
                      foregroundImage: state.supplierDetail.avatarUrl != null
                          ? NetworkImage(state.supplierDetail.avatarUrl!)
                          : null,
                      radius: 50,
                      child: state.supplierDetail.avatarUrl == null
                          ? Icon(
                              Icons.person_outline,
                              color: Colors.grey.shade400,
                              size: 50,
                            )
                          : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      onTapOutside: (event) => focusNode.unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Nama',
                      ),
                      initialValue: state.supplierDetail.name,
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      onTapOutside: (event) => focusNode.unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      initialValue: state.supplierDetail.email,
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      onTapOutside: (event) => focusNode.unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Telepon',
                      ),
                      initialValue: state.supplierDetail.phoneNumber,
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      onTapOutside: (event) => focusNode.unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                      ),
                      initialValue: state.supplierDetail.address,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
