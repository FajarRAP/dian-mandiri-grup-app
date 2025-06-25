import 'package:flutter/material.dart';

import '../../../../core/widgets/primary_button.dart';

class EditPurchaseNoteItemDialog extends StatefulWidget {
  const EditPurchaseNoteItemDialog({
    super.key,
    required this.onTap,
    required this.purchaseNoteItem,
  });

  final void Function(Map<String, dynamic> edited) onTap;
  final Map<String, dynamic> purchaseNoteItem;

  @override
  State<EditPurchaseNoteItemDialog> createState() =>
      _EditPurchaseNoteItemDialogState();
}

class _EditPurchaseNoteItemDialogState
    extends State<EditPurchaseNoteItemDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _rejectController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.purchaseNoteItem['name']);
    _priceController = TextEditingController(
        text: widget.purchaseNoteItem['price'].toString());
    _quantityController = TextEditingController(
        text: widget.purchaseNoteItem['quantity'].toString());
    _rejectController = TextEditingController(
        text: widget.purchaseNoteItem['reject'].toString());
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _rejectController.dispose();
  }

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
            controller: _nameController,
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
            controller: _priceController,
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
            controller: _quantityController,
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
            controller: _rejectController,
            decoration: InputDecoration(
              hintText: 'Total Barang Reject (Pcs)',
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () {
              final edited = {
                'name': _nameController.text,
                'price': int.tryParse(_priceController.text) ?? 0,
                'quantity': int.tryParse(_quantityController.text) ?? 0,
                'reject': int.tryParse(_rejectController.text) ?? 0,
              };
              widget.onTap(edited);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
