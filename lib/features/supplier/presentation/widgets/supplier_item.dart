import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

class SupplierItem extends StatelessWidget {
  const SupplierItem({
    super.key,
  });

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
          backgroundColor: CustomColors.primaryNormal,
          child: Text(
            'S1',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        subtitle: Text(
          'Alamat Supplier 1',
          style: textTheme.bodySmall?.copyWith(
            color: MaterialColors.onSurfaceVariant,
          ),
        ),
        tileColor: MaterialColors.onPrimary,
        title: Text(
          'Supplier 1',
          style: textTheme.bodyMedium,
        ),
      ),
    );
  }
}
