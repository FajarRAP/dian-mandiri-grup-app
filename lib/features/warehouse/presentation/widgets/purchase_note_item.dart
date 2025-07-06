import 'package:flutter/material.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/purchase_note_summary_entity.dart';

class PurchaseNoteItem extends StatelessWidget {
  const PurchaseNoteItem({
    super.key,
    required this.purchaseNoteSummary,
  });

  final PurchaseNoteSummaryEntity purchaseNoteSummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MaterialColors.onPrimary,
        boxShadow: cardBoxShadow,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '${purchaseNoteSummary.totalItems}',
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  purchaseNoteSummary.supplier.name,
                  style: textTheme.titleLarge,
                ),
                Text(
                  dateTimeFormat.format(purchaseNoteSummary.date.toLocal()),
                  style: textTheme.bodySmall?.copyWith(
                    color: MaterialColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}
