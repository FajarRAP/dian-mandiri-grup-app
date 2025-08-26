import 'package:flutter/material.dart';

import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class PurchaseNoteItemDialog extends StatelessWidget {
  const PurchaseNoteItemDialog({
    super.key,
    required this.onTap,
    required this.title,
    required this.nameController,
    required this.priceController,
    required this.totalController,
    required this.totalRejectController,
  });

  final void Function(WarehouseItemEntity item) onTap;
  final String title;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController totalController;
  final TextEditingController totalRejectController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MaterialColors.primaryContainer,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      color: MaterialColors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Silakan masukkan detail barang',
                          style: textTheme.bodyMedium?.copyWith(
                            color: MaterialColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text.rich(
                    TextSpan(
                      text: 'Nama Barang',
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: MaterialColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                validator: nullValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: priceController,
                decoration: const InputDecoration(
                  prefix: Text('Rp. '),
                  label: Text.rich(
                    TextSpan(
                      text: 'Harga per Barang',
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: MaterialColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: nullValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: totalController,
                decoration: const InputDecoration(
                  label: Text.rich(
                    TextSpan(
                      text: 'Total Barang',
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: MaterialColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffix: Text('pcs'),
                ),
                keyboardType: TextInputType.number,
                validator: nullValidator,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: totalRejectController,
                decoration: const InputDecoration(
                  label: Text('Total Barang Reject'),
                  suffix: Text('pcs'),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    final item = WarehouseItemEntity(
                      name: nameController.text,
                      price: int.parse(priceController.text),
                      quantity: int.parse(totalController.text),
                      rejectQuantity:
                          int.tryParse(totalRejectController.text) ?? 0,
                    );

                    onTap(item);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
