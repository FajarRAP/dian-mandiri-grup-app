import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/extensions.dart';

class SelectedPurchaseNoteItem extends StatelessWidget {
  const SelectedPurchaseNoteItem({
    super.key,
    required this.onDelete,
    required this.title,
  });

  final void Function() onDelete;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Container(
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: .circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        color: context.colorScheme.surfaceContainerLowest,
      ),
      height: 56,
      child: Row(
        children: <Widget>[
          Container(color: context.colorScheme.primary, width: 6),
          const Gap(10),
          Expanded(
            child: Text(
              title,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              overflow: .ellipsis,
            ),
          ),
          Tooltip(
            message: 'Hapus',
            child: IconButton(
              onPressed: onDelete,
              style: IconButton.styleFrom(
                backgroundColor: context.colorScheme.errorContainer,
              ),
              icon: Icon(Icons.close, color: context.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
