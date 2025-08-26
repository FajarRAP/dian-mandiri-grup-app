import 'package:flutter/material.dart';

import '../../domain/entities/warehouse_item_entity.dart';
import 'purchase_note_item_dialog.dart';

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
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _totalController;
  late final TextEditingController _totalRejectController;

  @override
  void initState() {
    super.initState();
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
    return PurchaseNoteItemDialog(
      onTap: widget.onTap,
      title: 'Tambah Barang',
      nameController: _nameController,
      priceController: _priceController,
      totalController: _totalController,
      totalRejectController: _totalRejectController,
    );
  }
}
