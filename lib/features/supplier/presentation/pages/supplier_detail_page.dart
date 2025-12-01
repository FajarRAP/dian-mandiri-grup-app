import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/presentation/widgets/error_state_widget.dart';
import '../../../../core/presentation/widgets/loading_indicator.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../cubit/supplier_detail/supplier_detail_cubit.dart';
import '../widgets/editable_avatar.dart';

class SupplierDetailPage extends StatefulWidget {
  const SupplierDetailPage({super.key, required this.supplierId});

  final String supplierId;

  @override
  State<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SupplierDetailCubit>().fetchSupplier(
      supplierId: widget.supplierId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Supplier')),
      body: BlocBuilder<SupplierDetailCubit, SupplierDetailState>(
        builder: (context, state) {
          return switch (state.status) {
            .inProgress => const LoadingIndicator(),
            .success => _SuccessWidget(supplier: state.supplier!),
            .failure => ErrorStateWidget(
              onRetry: () => context.read<SupplierDetailCubit>().fetchSupplier(
                supplierId: widget.supplierId,
              ),
              failure: state.failure,
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.supplier});

  final SupplierDetailEntity supplier;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(20),
          boxShadow: cardBoxShadow,
          color: context.colorScheme.onPrimary,
        ),
        margin: const .all(16),
        padding: const .all(24),
        child: Column(
          mainAxisSize: .min,
          children: <Widget>[
            EditableAvatar(imagePath: supplier.avatarUrl),
            const Gap(24),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama'),
              initialValue: supplier.name,
              readOnly: true,
            ),
            const Gap(12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: supplier.email,
              readOnly: true,
            ),
            const Gap(12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Telepon'),
              initialValue: supplier.phoneNumber,
              readOnly: true,
            ),
            const Gap(12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Alamat'),
              initialValue: supplier.address,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
