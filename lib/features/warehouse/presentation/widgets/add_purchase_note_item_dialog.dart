import 'package:flutter/material.dart';

import '../../../../core/widgets/primary_button.dart';

class AddPurchaseNoteItemDialog extends StatelessWidget {
  const AddPurchaseNoteItemDialog({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Nama',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Nama Barang',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Harga per Barang',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Harga per Barang',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Total Barang (Pcs)',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Total Barang (Pcs)',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Total Barang Reject (Pcs)',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Total Barang Reject (Pcs)',
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: onTap,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
