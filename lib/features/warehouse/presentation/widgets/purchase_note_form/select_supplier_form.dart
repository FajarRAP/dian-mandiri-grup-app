import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/common/dropdown_entity.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/dropdowns/supplier_dropdown.dart';

class SelectSupplierForm extends StatefulWidget {
  const SelectSupplierForm({
    super.key,
    required this.onTap,
    this.selectedSupplier,
  });

  final void Function(DropdownEntity supplier) onTap;
  final DropdownEntity? selectedSupplier;

  @override
  State<SelectSupplierForm> createState() => _SelectSupplierFormState();
}

class _SelectSupplierFormState extends State<SelectSupplierForm> {
  late final TextEditingController _supplierController;

  @override
  void initState() {
    super.initState();
    _supplierController = TextEditingController(
      text: widget.selectedSupplier?.value,
    );
  }

  @override
  void dispose() {
    _supplierController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SelectSupplierForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSupplier != oldWidget.selectedSupplier) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final newText = widget.selectedSupplier?.value ?? '';
        if (_supplierController.text != newText) {
          _supplierController.text = newText;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [
        Text('Pilih Supplier', style: textTheme.bodyLarge),
        TextFormField(
          onTap: () => showModalBottomSheet(
            builder: (context) => SupplierDropdown(
              onTap: (supplier) {
                widget.onTap(supplier);
                context.pop();
              },
            ),
            context: context,
            isScrollControlled: true,
          ),
          autovalidateMode: .onUserInteraction,
          controller: _supplierController,
          decoration: const InputDecoration(
            hintText: 'Pilih Supplier',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          readOnly: true,
          validator: nullValidator,
        ),
      ],
    );
  }
}
