import 'package:flutter/material.dart';

import '../../../../core/common/shadows.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: MaterialColors.onPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: cardBoxShadow,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
