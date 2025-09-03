import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/dropdowns/supplier_dropdown.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../../../../core/widgets/preview_picked_image_dialog.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/primary_outline_button.dart';
import '../../domain/entities/insert_purchase_note_file_entity.dart';
import '../cubit/warehouse_cubit.dart';

class AddPurchaseNoteFilePage extends StatefulWidget {
  const AddPurchaseNoteFilePage({super.key});

  @override
  State<AddPurchaseNoteFilePage> createState() =>
      _AddPurchaseNoteFilePageState();
}

class _AddPurchaseNoteFilePageState extends State<AddPurchaseNoteFilePage> {
  late final WarehouseCubit _warehouseCubit;
  late final GlobalKey<FormState> _formKey;
  late final FocusNode _focusNode;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;
  late final TextEditingController _supplierController;
  DateTime? _pickedDate;
  DropdownEntity? _selectedSupplier;
  XFile? _pickedImage;
  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    _warehouseCubit = context.read<WarehouseCubit>();
    _focusNode = FocusScope.of(context, createDependency: false);
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
      appBar: AppBar(
        title: const Text('Tambah Nota (Excel)'),
      ),
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
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: SupplierDropdown(
                    onTap: (supplier) {
                      _selectedSupplier = supplier;
                      _supplierController.text = supplier.value;
                      context.pop();
                    },
                  ),
                ),
                context: context,
                isScrollControlled: true,
              ),
              onTapOutside: (event) => _focusNode.unfocus(),
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
                  lastDate: DateTime.now(),
                  locale: const Locale('id', 'ID'),
                );

                if (pickedDate == null) return;
                _dateController.text = dMyFormat.format(pickedDate);
                _pickedDate = pickedDate;
              },
              onTapOutside: (event) => _focusNode.unfocus(),
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
                SizedBox(
                  width: 150,
                  child: PrimaryButton(
                    onPressed: () => showModalBottomSheet(
                      builder: (context) => ImagePickerBottomSheet(
                        onPicked: (image) =>
                            setState(() => _pickedImage = image),
                      ),
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: const Text('Ambil Gambar'),
                  ),
                ),
                if (_pickedImage != null) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 150,
                    child: PrimaryOutlineButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => PreviewPickedImageDialog(
                          pickedImagePath: _pickedImage?.path,
                        ),
                      ),
                      child: const Text('Preview Gambar'),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Catatan',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            TextFormField(
              onTapOutside: (event) => _focusNode.unfocus(),
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Tuliskan catatan jika ada',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            PrimaryOutlineButton(
              onPressed: () async {
                final file = await openFile(acceptedTypeGroups: [
                  XTypeGroup(
                    label: 'files',
                    extensions: <String>['xlsx', 'xls', 'csv'],
                  ),
                ]);

                if (file == null) return;
                setState(() => _pickedFile = file);
              },
              icon: Icon(Icons.folder),
              child: _pickedFile == null
                  ? const Text('Pilih File Excel')
                  : Text(_pickedFile!.name, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 24),
            BlocBuilder<WarehouseCubit, WarehouseState>(
              buildWhen: (previous, current) =>
                  current is InsertPurchaseNoteFileError,
              builder: (context, state) {
                if (state is InsertPurchaseNoteFileError) {
                  if (state.failure is! SpreadsheetFailure) {
                    return const SizedBox();
                  }

                  final spreadsheetFailure =
                      state.failure as SpreadsheetFailure;
                  final [headers, rows] =
                      parseSpreadsheetFailure(spreadsheetFailure);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Information
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.info_outline,
                            color: CustomColors.primaryNormal,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ketuk data pada setiap kolom untuk melihat detail error',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: TableBorder.all(
                            borderRadius: BorderRadius.circular(8.0),
                            color: MaterialColors.outlineVariant,
                          ),
                          clipBehavior: Clip.antiAlias,
                          columns: headers,
                          headingRowColor: WidgetStateProperty.all(
                              MaterialColors.surfaceContainer),
                          rows: rows,
                        ),
                      ),
                      if (spreadsheetFailure.hiddenColumnCount > 0) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: MaterialColors.error,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dan ${spreadsheetFailure.hiddenColumnCount} kolom lainnya tidak ditampilkan',
                              style: textTheme.bodyMedium?.copyWith(
                                color: MaterialColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
            const SizedBox(height: 144),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: FABContainer(
          child: BlocConsumer<WarehouseCubit, WarehouseState>(
            buildWhen: (previous, current) => current is InsertPurchaseNoteFile,
            listenWhen: (previous, current) =>
                current is InsertPurchaseNoteFile,
            listener: (context, state) {
              if (state is InsertPurchaseNoteFileLoaded) {
                TopSnackbar.successSnackbar(message: state.message);
                context.pop();
              }

              if (state is InsertPurchaseNoteFileError) {
                TopSnackbar.dangerSnackbar(message: state.failure.message);
              }
            },
            builder: (context, state) {
              if (state is InsertPurchaseNoteFileLoading) {
                return const PrimaryButton(
                  child: Text('Simpan'),
                );
              }

              return PrimaryButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  if (_pickedImage == null) {
                    const message = 'Silakan pilih gambar nota terlebih dahulu';
                    return TopSnackbar.dangerSnackbar(message: message);
                  }

                  if (_pickedFile == null) {
                    const message = 'Silakan pilih file barang terlebih dahulu';
                    return TopSnackbar.dangerSnackbar(message: message);
                  }

                  final purchaseNote = InsertPurchaseNoteFileEntity(
                    date: _pickedDate!,
                    note: _noteController.text,
                    receipt: _pickedImage!.path,
                    supplierId: _selectedSupplier!.key,
                    file: _pickedFile!.path,
                  );

                  _warehouseCubit.insertPurchaseNoteFile(
                      purchaseNote: purchaseNote);
                },
                child: const Text('Simpan'),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
