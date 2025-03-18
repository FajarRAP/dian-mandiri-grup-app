import 'package:flutter/material.dart';

class ShipDetailInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const ShipDetailInfoItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        SelectableText(
          value,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
