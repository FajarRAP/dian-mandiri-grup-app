import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

class ReceiptStatusInfoRow extends StatelessWidget {
  const ReceiptStatusInfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    required this.value,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: MaterialColors.primaryContainer,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: CustomColors.primaryNormal,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing ?? const SizedBox(),
      ],
    );
  }
}
