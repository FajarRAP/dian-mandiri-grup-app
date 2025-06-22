import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/supplier_entity.dart';

class SupplierItem extends StatelessWidget {
  const SupplierItem({
    super.key,
    required this.supplier,
  });

  final SupplierEntity supplier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(supplier.avatarUrl),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        subtitle: Text(
          supplier.phoneNumber,
          style: textTheme.bodySmall?.copyWith(
            color: MaterialColors.onSurfaceVariant,
          ),
        ),
        tileColor: MaterialColors.onPrimary,
        title: Text(
          supplier.name,
          style: textTheme.bodyMedium,
        ),
        trailing: IconButton(
          onPressed: () => context.push(
            editSupplierRoute,
            extra: supplier.id,
          ),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
