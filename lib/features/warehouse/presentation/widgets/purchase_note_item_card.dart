import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/extensions.dart';
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
    final textTheme = context.textTheme;

    return Card(
      color: context.colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: <Widget>[
                      Text(
                        warehouseItem.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      Text(
                        'Informasi Detail Barang',
                        style: textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isEditable)
                  Row(
                    mainAxisSize: .min,
                    children: <Widget>[
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined),
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          backgroundColor: context.colorScheme.primaryFixed
                              .withValues(alpha: .3),
                          foregroundColor: context.colorScheme.onPrimaryFixed,
                        ),
                        tooltip: 'Edit',
                      ),
                      const Gap(4),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        iconSize: 20,
                        style: IconButton.styleFrom(
                          backgroundColor: context.colorScheme.errorContainer
                              .withValues(alpha: .3),
                          foregroundColor: context.colorScheme.error,
                        ),
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),
              ],
            ),
            const Gap(12),
            const Divider(height: 1),
            const Gap(12),
            Text(
              'Informasi Barang',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade800,
                fontWeight: .w600,
              ),
            ),
            const Gap(6),
            _InfoRow(
              icon: Icons.inventory_2_outlined,
              label: 'Total Barang',
              value: '${warehouseItem.quantity} pcs',
            ),
            const Gap(4),
            _InfoRow(
              icon: Icons.cancel_outlined,
              label: 'Barang Reject',
              value: '${warehouseItem.rejectQuantity} pcs',
            ),
            const Gap(16),
            Text(
              'Informasi Harga',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade800,
                fontWeight: .w600,
              ),
            ),
            const Gap(6),
            _InfoRow(
              color: context.colorScheme.primary,
              icon: Icons.payments_outlined,
              label: 'Harga per Barang',
              value: warehouseItem.price.toIDRCurrency,
            ),
            const Gap(4),
            Container(
              decoration: BoxDecoration(
                border: .all(
                  color: context.colorScheme.primary.withValues(alpha: .3),
                ),
                borderRadius: .circular(6),
              ),
              padding: const .all(6),
              child: _InfoRow(
                color: context.colorScheme.primary,
                icon: Icons.calculate_outlined,
                label: 'Total Harga',
                value: warehouseItem.totalPrice.toIDRCurrency,
              ),
            ),
            const Gap(4),
            _InfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Ongkos Kirim',
              value: (warehouseItem.shipmentFee ?? 0).toIDRCurrency,
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
    final textTheme = context.textTheme;

    return Row(
      children: <Widget>[
        Icon(icon, color: color ?? Colors.grey.shade700, size: 16),
        const Gap(8),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: color == null ? .w400 : .w600,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            color: color ?? Colors.grey.shade800,
            fontWeight: color == null ? .w500 : .w700,
          ),
        ),
      ],
    );
  }
}
