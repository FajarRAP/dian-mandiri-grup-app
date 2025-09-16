import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: MaterialColors.shadow.withValues(alpha: .05),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          color: MaterialColors.onPrimary,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            // Item Count
            CircleAvatar(
              backgroundColor: CustomColors.primaryNormal.withValues(alpha: .1),
              radius: 24,
              child: Text(
                '${purchaseNoteSummary.totalItems}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: CustomColors.primaryNormal,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Supplier info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    purchaseNoteSummary.supplier.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateTimeFormat.format(purchaseNoteSummary.date.toLocal()),
                    style: textTheme.bodySmall?.copyWith(
                      color: MaterialColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Action button
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                color: MaterialColors.error,
              ),
              tooltip: 'Hapus',
            ),
          ],
        ),
      ),
    );
  }
}
