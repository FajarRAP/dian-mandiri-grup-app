import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

class PurchaseNoteItem extends StatelessWidget {
  const PurchaseNoteItem({
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
        leading: Text(
          '10',
          style: textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        subtitle: Text(
          'Tanggal Ditambahkan',
          style: textTheme.bodySmall?.copyWith(
            color: MaterialColors.onSurfaceVariant,
          ),
        ),
        tileColor: MaterialColors.onPrimary,
        title: Text(
          'Nama Nota',
          style: textTheme.titleLarge,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
