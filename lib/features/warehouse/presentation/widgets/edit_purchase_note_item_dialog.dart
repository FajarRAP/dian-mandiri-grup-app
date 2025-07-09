import 'package:flutter/material.dart';

import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class EditPurchaseNoteItemDialog extends StatefulWidget {
  const EditPurchaseNoteItemDialog({
    super.key,
    required this.onTap,
    required this.warehouseItemEntity,
  });

  final void Function(WarehouseItemEntity edited) onTap;
  final WarehouseItemEntity warehouseItemEntity;

  @override
  State<EditPurchaseNoteItemDialog> createState() =>
      _EditPurchaseNoteItemDialogState();
}

class _EditPurchaseNoteItemDialogState
    extends State<EditPurchaseNoteItemDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _rejectController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController =
        TextEditingController(text: widget.warehouseItemEntity.name);
    _priceController =
        TextEditingController(text: '${widget.warehouseItemEntity.price}');
    _quantityController =
        TextEditingController(text: '${widget.warehouseItemEntity.quantity}');
    _rejectController = TextEditingController(
        text: '${widget.warehouseItemEntity.rejectQuantity}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _rejectController.dispose();
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
              controller: _quantityController,
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
              controller: _rejectController,
              decoration: InputDecoration(
                hintText: 'Total Barang Reject (Pcs)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;

                final edited = WarehouseItemEntity(
                  name: _nameController.text,
                  price: int.parse(_priceController.text),
                  quantity: int.parse(_quantityController.text),
                  rejectQuantity: int.tryParse(_rejectController.text) ?? 0,
                );
                widget.onTap(edited);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
