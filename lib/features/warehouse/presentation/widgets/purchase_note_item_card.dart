import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class PurchaseNoteItemCard extends StatelessWidget {
  const PurchaseNoteItemCard({
    super.key,
    this.onDelete,
    this.onEdit,
    this.isEditable = true,
    required this.warehouseItem,
  });

  final void Function()? onDelete;
  final void Function()? onEdit;
  final bool isEditable;
  final WarehouseItemEntity warehouseItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      color: MaterialColors.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        warehouseItem.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Informasi Detail Barang',
                        style: textTheme.bodySmall?.copyWith(
                          color: MaterialColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isEditable)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          backgroundColor: MaterialColors.primaryContainer
                              .withValues(alpha: .3),
                          foregroundColor: MaterialColors.primary,
                        ),
                        tooltip: 'Edit',
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          backgroundColor: MaterialColors.errorContainer
                              .withValues(alpha: .3),
                          foregroundColor: MaterialColors.error,
                        ),
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Informasi Barang',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.inventory_2_outlined,
              label: 'Total Barang',
              value: '${warehouseItem.quantity} pcs',
            ),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.cancel_outlined,
              label: 'Barang Reject',
              value: '${warehouseItem.rejectQuantity} pcs',
            ),
            const SizedBox(height: 16),
            Text(
              'Informasi Harga',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            _InfoRow(
              color: CustomColors.primaryNormal,
              icon: Icons.payments_outlined,
              label: 'Harga per Barang',
              value: idrCurrencyFormat.format(warehouseItem.price),
            ),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: CustomColors.primaryNormal.withValues(alpha: .3),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(6),
              child: _InfoRow(
                color: CustomColors.primaryNormal,
                icon: Icons.calculate_outlined,
                label: 'Total Harga',
                value: idrCurrencyFormat
                    .format(warehouseItem.price * warehouseItem.quantity),
              ),
            ),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Ongkos Kirim',
              value: idrCurrencyFormat.format(warehouseItem.shipmentFee ?? 0),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    this.color,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color? color;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: color ?? Colors.grey.shade700,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: color == null ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            color: color ?? Colors.grey.shade800,
            fontWeight: color == null ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
