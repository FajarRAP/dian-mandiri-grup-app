import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class PurchaseNoteItemCard extends StatelessWidget {
  const PurchaseNoteItemCard({
    super.key,
    required this.onDelete,
    required this.onEdit,
    required this.warehouseItem,
  });

  final void Function() onDelete;
  final void Function() onEdit;
  final WarehouseItemEntity warehouseItem;

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
                  warehouseItem.name,
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
                  '${warehouseItem.quantity}',
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
                  '${warehouseItem.rejectQuantity}',
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
                  idrCurrencyFormat.format(warehouseItem.price),
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
                  idrCurrencyFormat
                      .format(warehouseItem.price * warehouseItem.quantity),
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
