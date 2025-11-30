import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/constants/app_images.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/supplier_entity.dart';
import '../cubit/supplier/new_supplier_cubit.dart';

class SupplierItem extends StatelessWidget {
  const SupplierItem({super.key, required this.supplier});

  final SupplierEntity supplier;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Material(
      shape: RoundedRectangleBorder(borderRadius: .circular(10)),
      elevation: 1,
      child: ListTile(
        onTap: () => context.pushNamed(
          Routes.supplierDetail,
          extra: {
            'supplier_id': supplier.id,
            'cubit': context.read<NewSupplierCubit>(),
          },
        ),
        leading: CircleAvatar(
          backgroundImage: const AssetImage(AppImages.app),
          foregroundImage: NetworkImage(supplier.avatarUrl ?? '-'),
        ),
        shape: RoundedRectangleBorder(borderRadius: .circular(10)),
        subtitle: Text(
          supplier.phoneNumber,
          style: textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        tileColor: context.colorScheme.onPrimary,
        title: Text(supplier.name, style: textTheme.bodyMedium),
        trailing: IconButton(
          onPressed: () => context.pushNamed(
            Routes.supplierEdit,
            extra: {
              'supplier_id': supplier.id,
              'cubit': context.read<NewSupplierCubit>(),
            },
          ),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
