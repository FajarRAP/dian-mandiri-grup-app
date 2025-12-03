import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../../core/presentation/widgets/buttons/primary_button.dart';
import '../../../../core/presentation/widgets/buttons/primary_outline_button.dart';
import '../../../../core/presentation/widgets/fab_container.dart';
import '../cubit/import_purchase_note/import_purchase_note_cubit.dart';
import '../widgets/purchase_note_form/note_form.dart';
import '../widgets/purchase_note_form/select_date_form.dart';
import '../widgets/purchase_note_form/select_supplier_form.dart';
import '../widgets/purchase_note_form/upload_receipt_form.dart';

class ImportPurchaseNotePage extends StatefulWidget {
  const ImportPurchaseNotePage({super.key});

  @override
  State<ImportPurchaseNotePage> createState() => _ImportPurchaseNotePageState();
}

class _ImportPurchaseNotePageState extends State<ImportPurchaseNotePage> {
  late final ImportPurchaseNoteCubit _importPurchaseNoteCubit;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _importPurchaseNoteCubit = context.read<ImportPurchaseNoteCubit>();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final supplier = context.select<ImportPurchaseNoteCubit, DropdownEntity?>(
      (value) => value.state.supplier,
    );
    final date = context.select<ImportPurchaseNoteCubit, DateTime?>(
      (value) => value.state.date,
    );
    final image = context.select<ImportPurchaseNoteCubit, File?>(
      (value) => value.state.image,
    );

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Nota (Excel)')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const .all(16),
            children: <Widget>[
              SelectSupplierForm(
                onTap: (supplier) =>
                    _importPurchaseNoteCubit.supplier = supplier,
                selectedSupplier: supplier,
              ),
              const Gap(12),
              SelectDateForm(
                onTap: (date) => _importPurchaseNoteCubit.date = date,
                pickedDate: date,
              ),
              const Gap(12),
              UploadReceiptForm(
                onPicked: (file) => _importPurchaseNoteCubit.image = file,
                image: image,
              ),
              const Gap(12),
              NoteForm(
                onChanged: (value) => _importPurchaseNoteCubit.note = value,
              ),
              const Gap(24),
              const Divider(height: 1),
              const Gap(24),
              BlocSelector<
                ImportPurchaseNoteCubit,
                ImportPurchaseNoteState,
                File?
              >(
                selector: (state) => state.file,
                builder: (context, file) {
                  final child = file == null
                      ? const Text('Pilih File Excel')
                      : Text(file.fileName, overflow: .ellipsis);

                  return PrimaryOutlineButton(
                    onPressed: _importPurchaseNoteCubit.pickFile,
                    icon: const Icon(Icons.folder),
                    child: child,
                  );
                },
              ),
              const _SpreadsheetFailureResult(),
              const Gap(144),
            ],
          ),
        ),
        floatingActionButton: _FAB(formKey: _formKey),
        floatingActionButtonLocation: .centerDocked,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class _SpreadsheetFailureResult extends StatelessWidget {
  const _SpreadsheetFailureResult();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return BlocSelector<
      ImportPurchaseNoteCubit,
      ImportPurchaseNoteState,
      Failure?
    >(
      selector: (state) => state.failure,
      builder: (context, state) {
        if (state == null || state is! SpreadsheetFailure) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: .start,
          children: <Widget>[
            const Gap(24),
            // Information
            Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline,
                  color: context.colorScheme.primary,
                  size: 18,
                ),
                const Gap(8),
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
            const Gap(16),
            // Table
            SingleChildScrollView(
              scrollDirection: .horizontal,
              child: DataTable(
                border: .all(
                  borderRadius: .circular(8.0),
                  color: context.colorScheme.outlineVariant,
                ),
                clipBehavior: .antiAlias,
                columns: _buildHeaders(state.headers),
                headingRowColor: .all(context.colorScheme.surfaceContainer),
                rows: _buildRows(context, state.rows),
              ),
            ),
            if (state.hiddenColumnCount > 0) ...[
              const Gap(16),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.warning_amber_rounded,
                    color: context.colorScheme.error,
                    size: 18,
                  ),
                  const Gap(8),
                  Text(
                    'Dan ${state.hiddenColumnCount} kolom lainnya tidak ditampilkan',
                    style: textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.error,
                      fontWeight: .w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB({required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FABContainer(
        child: BlocConsumer<ImportPurchaseNoteCubit, ImportPurchaseNoteState>(
          listener: (context, state) {
            if (state.status == .success) {
              TopSnackbar.successSnackbar(message: state.message!);
              context.pop(true);
            }

            if (state.status == .failure) {
              TopSnackbar.dangerSnackbar(message: state.failure!.message);
            }
          },
          builder: (context, state) {
            final onPressed = switch (state.status) {
              .inProgress => null,
              _ => () {
                if (!formKey.currentState!.validate()) return;

                context.read<ImportPurchaseNoteCubit>().importPurchaseNote();
              },
            };

            return PrimaryButton(
              onPressed: onPressed,
              child: const Text('Simpan'),
            );
          },
        ),
      ),
    );
  }
}

List<DataColumn> _buildHeaders(List<String> headers) {
  return headers
      .map((e) => DataColumn(label: Text(e), headingRowAlignment: .center))
      .toList();
}

List<DataRow> _buildRows(BuildContext context, List<ListJsonMapNullable> rows) {
  return List.generate(rows.length, (index) {
    final row = rows[index];
    final rowColor = index.isEven ? Colors.white : Colors.grey.shade50;

    return DataRow(
      color: .all(rowColor),
      cells: row.map((cell) {
        final errorText = cell?['error'] as String?;
        final hasError = errorText != null && errorText.isNotEmpty;
        final cellValue = cell?['value']?.toString() ?? '-';

        return DataCell(
          Container(
            color: hasError ? context.colorScheme.errorContainer : null,
            padding: const .symmetric(horizontal: 8),
            width: .infinity,
            child: Tooltip(
              triggerMode: .tap,
              message: errorText ?? '',
              child: Row(
                children: [
                  if (hasError) ...[
                    Icon(
                      Icons.warning,
                      size: 14,
                      color: context.colorScheme.error,
                    ),
                    const Gap(4),
                  ],
                  Expanded(
                    child: Text(
                      cellValue,
                      style: TextStyle(
                        color: hasError ? context.colorScheme.error : null,
                        fontWeight: hasError ? .w700 : null,
                      ),
                      overflow: .ellipsis,
                      textAlign: .center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  });
}
