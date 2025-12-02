import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/primary_outline_button.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../domain/entities/warehouse_item_entity.dart';
import '../cubit/purchase_note_form/purchase_note_form_cubit.dart';
import '../widgets/purchase_note_form/note_form.dart';
import '../widgets/purchase_note_form/select_date_form.dart';
import '../widgets/purchase_note_form/select_supplier_form.dart';
import '../widgets/purchase_note_form/upload_receipt_form.dart';
import '../widgets/purchase_note_item_card.dart';
import '../widgets/purchase_note_item_dialog.dart';

class CreatePurchaseNotePage extends StatefulWidget {
  const CreatePurchaseNotePage({super.key});

  @override
  State<CreatePurchaseNotePage> createState() => _CreatePurchaseNotePageState();
}

class _CreatePurchaseNotePageState extends State<CreatePurchaseNotePage> {
  late final PurchaseNoteFormCubit _createPurchaseNoteCubit;
  late final TextEditingController _supplierController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _createPurchaseNoteCubit = context.read<PurchaseNoteFormCubit>();
    _supplierController = TextEditingController();
    _dateController = TextEditingController();
    _noteController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _supplierController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supplier = context.select<PurchaseNoteFormCubit, DropdownEntity?>(
      (cubit) => cubit.state.supplier,
    );
    final date = context.select<PurchaseNoteFormCubit, DateTime?>(
      (cubit) => cubit.state.date,
    );
    final image = context.select<PurchaseNoteFormCubit, File?>(
      (cubit) => cubit.state.image,
    );
    final items = context
        .select<PurchaseNoteFormCubit, List<WarehouseItemEntity>>(
          (cubit) => cubit.state.items,
        );

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Nota')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const .all(16),
            children: [
              SelectSupplierForm(
                onTap: (supplier) =>
                    _createPurchaseNoteCubit.supplier = supplier,
                selectedSupplier: supplier,
              ),
              const Gap(12),
              SelectDateForm(
                onTap: (date) => _createPurchaseNoteCubit.date = date,
                pickedDate: date,
              ),
              const Gap(12),
              UploadReceiptForm(
                onPicked: (file) => _createPurchaseNoteCubit.image = file,
                image: image,
              ),
              const Gap(12),
              NoteForm(
                onChanged: (value) => _createPurchaseNoteCubit.note = value,
              ),
              const Gap(24),
              const Divider(height: 1),
              const Gap(24),
              PrimaryOutlineButton(
                onPressed: () => showDialog(
                  builder: (_) => PurchaseNoteItemDialog(
                    onSave: (item) {
                      _createPurchaseNoteCubit.items = [
                        ..._createPurchaseNoteCubit.state.items,
                        item,
                      ];
                      context.pop();
                    },
                    title: 'Tambah Barang',
                  ),
                  context: context,
                ),
                icon: SvgPicture.asset(
                  boxSvg,
                  colorFilter: .mode(context.colorScheme.primary, .srcIn),
                ),
                child: const Text('Tambah Barang'),
              ),
              const Gap(12),
              ListView.separated(
                itemBuilder: (context, index) => PurchaseNoteItemCard(
                  onDelete: () => _createPurchaseNoteCubit.removeItemAt(index),
                  onEdit: () => showDialog(
                    context: context,
                    builder: (_) => PurchaseNoteItemDialog(
                      onSave: (edited) {
                        _createPurchaseNoteCubit.updateItemAt(index, edited);
                        context.pop();
                      },
                      title: 'Edit Barang',
                      initialItem: items[index],
                    ),
                  ),
                  warehouseItem: items[index],
                ),
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: items.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
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

class _FAB extends StatelessWidget {
  const _FAB({required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return BlocConsumer<PurchaseNoteFormCubit, PurchaseNoteFormState>(
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

            context.read<PurchaseNoteFormCubit>().submit();
          },
        };

        return FABContainer(
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: <Widget>[
              Row(
                mainAxisAlignment: .spaceBetween,
                children: <Widget>[
                  Text('Total semua harga', style: textTheme.bodyMedium),
                  Text(
                    state.totalAmount.toIDRCurrency,
                    style: textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              PrimaryButton(onPressed: onPressed, child: const Text('Simpan')),
            ],
          ),
        );
      },
    );
  }
}
