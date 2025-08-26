import 'package:flutter/material.dart';

import '../../domain/entities/warehouse_item_entity.dart';
import 'purchase_note_item_dialog.dart';

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
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _totalController;
  late final TextEditingController _totalRejectController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.warehouseItemEntity.name);
    _priceController =
        TextEditingController(text: '${widget.warehouseItemEntity.price}');
    _totalController =
        TextEditingController(text: '${widget.warehouseItemEntity.quantity}');
    _totalRejectController = TextEditingController(
        text: '${widget.warehouseItemEntity.rejectQuantity}');
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
    return PurchaseNoteItemDialog(
      onTap: widget.onTap,
      title: 'Edit Barang',
      nameController: _nameController,
      priceController: _priceController,
      totalController: _totalController,
      totalRejectController: _totalRejectController,
    );
  }
}
