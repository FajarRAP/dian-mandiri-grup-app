import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';

class PurchaseNoteItemCard extends StatelessWidget {
  const PurchaseNoteItemCard({
    super.key,
    required this.onDelete,
    required this.onEdit,
    required this.purchaseNoteItem,
  });

  final void Function() onDelete;
  final void Function() onEdit;
  final Map<String, dynamic> purchaseNoteItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      color: MaterialColors.onPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  purchaseNoteItem['name'],
                  style: textTheme.bodyMedium,
                ),
                const Spacer(),
                InkWell(
                  onTap: onDelete,
                  child: Text(
                    'Hapus',
                    style: textTheme.bodySmall?.copyWith(
                      color: MaterialColors.error,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: onEdit,
                  child: Text(
                    'Edit',
                    style: textTheme.bodySmall?.copyWith(
                      color: CustomColors.primaryNormal,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Barang (Pcs)',
                  style: textTheme.bodySmall,
                ),
                Text(
                  purchaseNoteItem['quantity'].toString(),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Barang Reject (Pcs)',
                  style: textTheme.bodySmall,
                ),
                Text(
                  purchaseNoteItem['reject'].toString(),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Harga per Barang',
                  style: textTheme.bodySmall,
                ),
                Text(
                  idrCurrencyFormat.format(purchaseNoteItem['price']),
                  style: textTheme.bodySmall?.copyWith(
                    color: CustomColors.primaryNormal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Harga Barang',
                  style: textTheme.bodySmall,
                ),
                Text(
                  idrCurrencyFormat.format(
                      purchaseNoteItem['price'] * purchaseNoteItem['quantity']),
                  style: textTheme.bodySmall?.copyWith(
                    color: CustomColors.primaryNormal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
