import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/dropdown_modal_item.dart';
import '../../../../core/widgets/dropdown_search_modal.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_outline_button.dart';
import '../../../../core/widgets/primary_outline_icon_button.dart';
import '../../../supplier/presentation/cubit/supplier_cubit.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/entities/warehouse_item_entity.dart';
import '../cubit/warehouse_cubit.dart';
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
  late final WarehouseCubit _warehouseCubit;
  late final ImagePicker _imagePicker;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;
  late final TextEditingController _supplierController;
  final _items = <WarehouseItemEntity>[];
  DateTime? _pickedDate;
  DropdownEntity? _selectedSupplier;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _supplierCubit = context.read<SupplierCubit>();
    _warehouseCubit = context.read<WarehouseCubit>();
    _imagePicker = ImagePicker();
    _formKey = GlobalKey<FormState>();
    _dateController = TextEditingController();
    _noteController = TextEditingController();
    _supplierController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _noteController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Nota')),
      body: Form(
        key: _formKey,
        child: ListView(
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
                  search: (keyword) =>
                      _supplierCubit.fetchSuppliersDropdown(search: keyword),
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
                                _supplierController.text =
                                    state.suppliers[index].value;
                                _selectedSupplier = state.suppliers[index];
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _supplierController,
              decoration: InputDecoration(
                hintText: 'Pilih Supplier',
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
              validator: nullValidator,
            ),
            const SizedBox(height: 12),
            Text(
              'Tanggal',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextFormField(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  initialDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  locale: const Locale('id', 'ID'),
                );

                if (pickedDate == null) return;
                _dateController.text = dMyFormat.format(pickedDate);
                _pickedDate = pickedDate;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _dateController,
              decoration: InputDecoration(
                hintText: 'Tanggal',
                suffixIcon: const Icon(Icons.date_range),
              ),
              readOnly: true,
              validator: nullValidator,
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
                  onPressed: () async {
                    final pickedImage = await _imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (pickedImage == null) return;

                    setState(() => _pickedImage = pickedImage);
                  },
                  width: 150,
                  child: const Text('Pilih Gambar'),
                ),
                const SizedBox(height: 6),
                PrimaryOutlineButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      alignment: Alignment.center,
                      content: _pickedImage == null
                          ? Text(
                              'Belum memilih gambar',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Image.file(
                              File(_pickedImage!.path),
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
                    text: ' ${_items.length}',
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
              controller: _noteController,
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
                    final item = WarehouseItemEntity(
                      name: 'Barang ${_items.length + 1}',
                      price: 10000 + (_items.length * 1000),
                      quantity: 10 + _items.length,
                      rejectQuantity: 2 + _items.length,
                    );
                    setState(() => _items.add(item));
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
                    warehouseItemEntity: _items[index],
                  ),
                ),
                warehouseItem: _items[index],
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: _items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            const SizedBox(height: 144),
          ],
        ),
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
                    _items.fold(0, (prev, e) => prev + (e.price * e.quantity)),
                  ),
                  style: textTheme.bodyLarge?.copyWith(
                    color: CustomColors.primaryNormal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocConsumer<WarehouseCubit, WarehouseState>(
              buildWhen: (previous, current) =>
                  current is InsertPurchaseNoteManual,
              listenWhen: (previous, current) =>
                  current is InsertPurchaseNoteManual,
              listener: (context, state) {
                if (state is InsertPurchaseNoteManualLoaded) {
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    successSnackbar(state.message),
                  );
                  context.pop();
                  _warehouseCubit.fetchPurchaseNotes();
                }
              },
              builder: (context, state) {
                if (state is InsertPurchaseNoteManualLoading) {
                  return const PrimaryButton(child: Text('Simpan'));
                }

                return PrimaryButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    if (_pickedImage == null) {
                      const message =
                          'Silakan pilih gambar nota terlebih dahulu';
                      scaffoldMessengerKey.currentState?.showSnackBar(
                        dangerSnackbar(message),
                      );
                      return;
                    }

                    _warehouseCubit.insertPurchaseNoteManual(
                      purchaseNote: InsertPurchaseNoteManualEntity(
                        date: _pickedDate!,
                        receipt: _pickedImage!.path,
                        note: _noteController.text,
                        supplierId: _selectedSupplier!.key,
                        items: _items,
                      ),
                    );
                  },
                  child: const Text('Simpan'),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
