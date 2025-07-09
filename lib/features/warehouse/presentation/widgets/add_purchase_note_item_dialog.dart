import 'package:flutter/material.dart';

import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class AddPurchaseNoteItemDialog extends StatefulWidget {
  const AddPurchaseNoteItemDialog({
    super.key,
    required this.onTap,
  });

  final void Function(WarehouseItemEntity item) onTap;

  @override
  State<AddPurchaseNoteItemDialog> createState() =>
      _AddPurchaseNoteItemDialogState();
}

class _AddPurchaseNoteItemDialogState extends State<AddPurchaseNoteItemDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _totalController;
  late final TextEditingController _totalRejectController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _totalController = TextEditingController();
    _totalRejectController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _totalController.dispose();
    _totalRejectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Nama',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nama Barang',
              ),
              validator: nullValidator,
            ),
            const SizedBox(height: 12),
            Text(
              'Harga per Barang',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _priceController,
              decoration: InputDecoration(
                hintText: 'Harga per Barang',
              ),
              keyboardType: TextInputType.number,
              validator: nullValidator,
            ),
            const SizedBox(height: 12),
            Text(
              'Total Barang (Pcs)',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _totalController,
              decoration: InputDecoration(
                hintText: 'Total Barang (Pcs)',
              ),
              keyboardType: TextInputType.number,
              validator: nullValidator,
            ),
            const SizedBox(height: 12),
            Text(
              'Total Barang Reject (Pcs)',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _totalRejectController,
              decoration: InputDecoration(
                hintText: 'Total Barang Reject (Pcs)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;

                final item = WarehouseItemEntity(
                  name: _nameController.text,
                  price: int.parse(_priceController.text),
                  quantity: int.parse(_totalController.text),
                  rejectQuantity:
                      int.tryParse(_totalRejectController.text) ?? 0,
                );

                widget.onTap(item);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
