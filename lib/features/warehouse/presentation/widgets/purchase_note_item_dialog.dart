import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/validators.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/required_label.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class PurchaseNoteItemDialog extends StatefulWidget {
  const PurchaseNoteItemDialog({
    super.key,
    required this.onSave,
    required this.title,
    this.initialItem,
  });

  final void Function(WarehouseItemEntity item) onSave;
  final String title;
  final WarehouseItemEntity? initialItem;

  @override
  State<PurchaseNoteItemDialog> createState() => _PurchaseNoteItemDialogState();
}

class _PurchaseNoteItemDialogState extends State<PurchaseNoteItemDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _totalController;
  late final TextEditingController _totalRejectController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name);
    _priceController = TextEditingController(
      text: item?.price.toString() ?? '',
    );
    _totalController = TextEditingController(
      text: item?.quantity.toString() ?? '',
    );
    _totalRejectController = TextEditingController(
      text: item?.rejectQuantity.toString() ?? '',
    );
    _formKey = GlobalKey<FormState>();
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
    final textTheme = context.textTheme;

    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(borderRadius: .circular(20)),
        padding: const .all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      color: context.colorScheme.primaryFixed,
                    ),
                    padding: const .all(12),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      color: context.colorScheme.onPrimaryFixed,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: .w700,
                          ),
                        ),
                        Text(
                          'Silakan masukkan detail barang',
                          style: textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(28),
              TextFormField(
                autovalidateMode: .onUserInteraction,
                controller: _nameController,
                decoration: const InputDecoration(
                  label: RequiredLabel(label: 'Nama Barang'),
                ),
                validator: nullValidator,
              ),
              const Gap(20),
              TextFormField(
                autovalidateMode: .onUserInteraction,
                controller: _priceController,
                decoration: const InputDecoration(
                  prefix: Text('Rp. '),
                  label: RequiredLabel(label: 'Harga per Barang'),
                ),
                keyboardType: TextInputType.number,
                validator: nullValidator,
              ),
              const Gap(20),
              TextFormField(
                autovalidateMode: .onUserInteraction,
                controller: _totalController,
                decoration: const InputDecoration(
                  label: RequiredLabel(label: 'Total Barang'),
                  suffix: Text('pcs'),
                ),
                keyboardType: TextInputType.number,
                validator: nullValidator,
              ),
              const Gap(20),
              TextFormField(
                controller: _totalRejectController,
                decoration: const InputDecoration(
                  label: Text('Total Barang Reject'),
                  suffix: Text('pcs'),
                ),
                keyboardType: TextInputType.number,
              ),
              const Gap(32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    final newItem = WarehouseItemEntity(
                      name: _nameController.text,
                      price: int.parse(_priceController.text),
                      quantity: int.parse(_totalController.text),
                      rejectQuantity:
                          int.tryParse(_totalRejectController.text) ?? 0,
                    );

                    widget.onSave(newItem);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
      contentPadding: .zero,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
    );
  }
}
