import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/dropdowns/supplier_dropdown.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/preview_picked_image_dialog.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_outline_button.dart';
import '../../../../core/widgets/primary_outline_icon_button.dart';
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
  late final ImagePicker _imagePicker;
  late final GlobalKey<FormState> _formKey;
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
                builder: (context) => SupplierDropdown(
                  onTap: (supplier) {
                    _selectedSupplier = supplier;
                    _supplierController.text = supplier.value;
                    context.pop();
                  },
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
                  lastDate: DateTime.now(),
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
                    builder: (context) => PreviewPickedImageDialog(
                      pickedImagePath: _pickedImage?.path,
                    ),
                  ),
                  width: 150,
                  child: const Text('Preview Gambar'),
                ),
              ],
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
              label: _pickedFile == null
                  ? Text('Tambah Barang')
                  : Text(_pickedFile!.name, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 24),
            BlocBuilder<WarehouseCubit, WarehouseState>(
              buildWhen: (previous, current) =>
                  current is InsertPurchaseNoteFileError,
              builder: (context, state) {
                if (state is InsertPurchaseNoteFileError) {
                  final spreadsheetFailure =
                      state.failure as SpreadsheetFailure;
                  final headers = spreadsheetFailure.headers
                      .map((e) => DataColumn(label: Text(e)))
                      .toList();
                  final rows = spreadsheetFailure.rows
                      .map((e) => DataRow(
                          cells: e
                              .map((el) => DataCell(Text(el?['value'] ?? '')))
                              .toList()))
                      .toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DataTable(
                          columns: headers,
                          rows: rows,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dan ${spreadsheetFailure.hiddenColumnCount} kolom tersembunyi lainnya',
                          style: textTheme.bodyMedium?.copyWith(
                            color: MaterialColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 144),
          ],
        ),
      ),
      floatingActionButton: FABContainer(
        child: BlocConsumer<WarehouseCubit, WarehouseState>(
          buildWhen: (previous, current) => current is InsertPurchaseNoteFile,
          listenWhen: (previous, current) => current is InsertPurchaseNoteFile,
          listener: (context, state) {
            if (state is InsertPurchaseNoteFileLoaded) {
              scaffoldMessengerKey.currentState?.showSnackBar(
                successSnackbar(state.message),
              );
              context.pop();
              _warehouseCubit.fetchPurchaseNotes();
            }

            if (state is InsertPurchaseNoteFileError) {
              scaffoldMessengerKey.currentState?.showSnackBar(
                dangerSnackbar(state.failure.message),
              );
            }
          },
          builder: (context, state) {
            if (state is InsertPurchaseNoteFileLoading) {
              return const PrimaryButton(child: Text('Simpan'));
            }

            return PrimaryButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;

                if (_pickedImage == null) {
                  const message = 'Silakan pilih gambar nota terlebih dahulu';
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    dangerSnackbar(message),
                  );
                  return;
                }

                if (_pickedFile == null) {
                  const message = 'Silakan pilih file barang terlebih dahulu';
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    dangerSnackbar(message),
                  );
                  return;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
