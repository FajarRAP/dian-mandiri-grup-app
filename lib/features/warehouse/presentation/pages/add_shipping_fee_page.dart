import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/dropdown_modal_item.dart';
import '../../../../core/widgets/dropdown_search_modal.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/primary_button.dart';

class AddShippingFeePage extends StatefulWidget {
  const AddShippingFeePage({
    super.key,
  });

  @override
  State<AddShippingFeePage> createState() => _AddShippingFeePageState();
}

class _AddShippingFeePageState extends State<AddShippingFeePage> {
  final _selectedPurchaseNoteIds = <DropdownEntity>[];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Ongkos Kirim'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Harga Ongkos Kirim',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Harga Ongkos Kirim',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          Text(
            'Pilih Nota',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          TextField(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => DropdownSearchModal(
                search: (keyword) {},
                title: 'nota',
                child: Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPurchaseNoteIds.add(
                            DropdownEntity(
                              key: '$index',
                              value: 'Nota $index',
                            ),
                          );
                        });
                        context.pop();
                      },
                      child: DropdownModalItem(
                        child: Text(
                          'Nota $index',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: 10,
                  ),
                ),
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Pilih nota',
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 24),
          Divider(color: MaterialColors.outlineVariant),
          const SizedBox(height: 24),
          ListView.separated(
            itemBuilder: (context, index) => Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: MaterialColors.surfaceContainerLowest,
                title: Text(_selectedPurchaseNoteIds[index].value),
                trailing: IconButton(
                  onPressed: () =>
                      setState(() => _selectedPurchaseNoteIds.removeAt(index)),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: _selectedPurchaseNoteIds.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
        ],
      ),
      floatingActionButton: FABContainer(
        child: PrimaryButton(
          onPressed: () {},
          child: const Text('Simpan'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
