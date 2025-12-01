import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';

class PurchaseNoteItem extends StatelessWidget {
  const PurchaseNoteItem({
    super.key,
    this.onDelete,
    this.onTap,
    required this.purchaseNoteSummary,
  });

  final void Function()? onDelete;
  final void Function()? onTap;
  final PurchaseNoteSummaryEntity purchaseNoteSummary;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: .all(
            color: context.colorScheme.outline.withValues(alpha: .3),
            width: .5,
          ),
          borderRadius: .circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: .05),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          color: context.colorScheme.onPrimary,
        ),
        padding: const .all(16),
        child: Row(
          children: <Widget>[
            // Item Count
            CircleAvatar(
              backgroundColor: context.colorScheme.primary.withValues(
                alpha: .1,
              ),
              radius: 24,
              child: Text(
                '${purchaseNoteSummary.totalItems}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: .w700,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            const Gap(16),

            // Supplier info
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  Text(
                    purchaseNoteSummary.supplier.name,
                    style: textTheme.titleLarge?.copyWith(fontWeight: .w600),
                  ),
                  const Gap(4),
                  Text(
                    dateTimeFormat.format(purchaseNoteSummary.date.toLocal()),
                    style: textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Action button
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: context.colorScheme.error,
              ),
              tooltip: 'Hapus',
            ),
          ],
        ),
      ),
    );
  }
}
