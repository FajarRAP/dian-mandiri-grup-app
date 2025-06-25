import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/dropdown_modal_item.dart';
import '../../../../core/widgets/dropdown_search_modal.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_outline_button.dart';
import '../../../../core/widgets/primary_outline_icon_button.dart';
import '../../../supplier/presentation/cubit/supplier_cubit.dart';
import '../widgets/add_purchase_note_item_dialog.dart';
import '../widgets/edit_purchase_note_item_dialog.dart';
import '../widgets/purchase_note_item_card.dart';

class AddPurchaseNoteManualPage extends StatefulWidget {
  const AddPurchaseNoteManualPage({
    super.key,
  });

  @override
  State<AddPurchaseNoteManualPage> createState() =>
      _AddPurchaseNoteManualPageState();
}

class _AddPurchaseNoteManualPageState extends State<AddPurchaseNoteManualPage> {
  late final SupplierCubit _supplierCubit;

  final _items = <Map<String, dynamic>>[
    {
      'name': 'Barang 1',
      'price': 10000,
      'quantity': 10,
      'reject': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _supplierCubit = context.read<SupplierCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Nota')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Pilih Supplier',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          TextFormField(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) => DropdownSearchModal(
                search: (keyword) {},
                title: 'supplier',
                child: Expanded(
                  child: BlocBuilder<SupplierCubit, SupplierState>(
                    bloc: _supplierCubit..fetchSuppliersDropdown(),
                    buildWhen: (previous, current) =>
                        current is FetchSuppliersDropdown,
                    builder: (context, state) {
                      if (state is FetchSuppliersDropdownLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (state is FetchSuppliersDropdownLoaded) {
                        return ListView.separated(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: DropdownModalItem(
                                child: Text(state.suppliers[index].value)),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemCount: state.suppliers.length,
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Pilih Supplier',
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 12),
          Text(
            'Tanggal',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          TextFormField(
            onTap: () => showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              initialDate: DateTime.now(),
              lastDate: DateTime(2100),
              locale: const Locale('id', 'ID'),
            ),
            decoration: InputDecoration(
              hintText: 'Tanggal',
              suffixIcon: const Icon(Icons.date_range),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 12),
          Text(
            'Unggah Gambar Nota',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PrimaryButton(
                onPressed: () {},
                width: 150,
                child: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 6),
              PrimaryOutlineButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Image.asset(
                      spreadsheetIcon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                width: 150,
                child: const Text('Preview Gambar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: 'Jumlah Barang',
              style: textTheme.bodyLarge,
              children: <TextSpan>[
                TextSpan(
                  text: ' 10',
                  style: textTheme.bodyLarge?.copyWith(
                    color: MaterialColors.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Catatan',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Tuliskan catatan jika ada',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Divider(),
          const SizedBox(height: 24),
          PrimaryOutlineIconButton(
            onPressed: () => showDialog(
              builder: (context) => AddPurchaseNoteItemDialog(
                onTap: () {
                  setState(() {
                    _items.add({
                      'name': 'Barang ${_items.length + 1}',
                      'price': 10000 + (_items.length * 1000),
                      'quantity': 10 + _items.length,
                      'reject': 2 + _items.length,
                    });
                  });
                  context.pop();
                },
              ),
              context: context,
              useSafeArea: false,
            ),
            icon: SvgPicture.asset(
              boxSvg,
              colorFilter: ColorFilter.mode(
                CustomColors.primaryNormal,
                BlendMode.srcIn,
              ),
            ),
            label: Text('Tambah Barang'),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            itemBuilder: (context, index) => PurchaseNoteItemCard(
              onDelete: () => setState(() => _items.removeAt(index)),
              onEdit: () => showDialog(
                context: context,
                builder: (context) => EditPurchaseNoteItemDialog(
                  onTap: (edited) {
                    setState(() => _items[index] = edited);
                    context.pop();
                  },
                  purchaseNoteItem: _items[index],
                ),
              ),
              purchaseNoteItem: _items[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: _items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          const SizedBox(height: 144),
        ],
      ),
      floatingActionButton: FABContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total semua harga',
                  style: textTheme.bodyMedium,
                ),
                Text(
                  idrCurrencyFormat.format(
                    _items.fold(
                      0,
                      (previousValue, element) => previousValue +
                          (element['price'] * element['quantity']) as int,
                    ),
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: CustomColors.primaryNormal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              onPressed: () {},
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
