import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        color: MaterialColors.onPrimary,
      ),
      height: 56,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              color: CustomColors.primaryNormal,
            ),
            height: 56,
            width: 6,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            message: 'Hapus',
            child: IconButton(
              onPressed: onDelete,
              style: IconButton.styleFrom(
                backgroundColor: MaterialColors.error.withValues(alpha: .1),
              ),
              icon: const Icon(
                Icons.close,
                color: MaterialColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
