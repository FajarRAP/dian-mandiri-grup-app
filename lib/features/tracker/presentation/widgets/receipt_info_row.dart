import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';

class ReceiptInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSelectable;

  const ReceiptInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green.withValues(alpha: 0.1),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: Colors.green,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              if (isSelectable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    scaffoldMessengerKey.currentState?.showSnackBar(
                        successSnackbar('$label disalin ke clipboard'));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.copy,
                        size: 16,
                        color: Colors.green,
                      ),
                    ],
                  ),
                )
              else
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
