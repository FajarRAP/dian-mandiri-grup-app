import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/primary_outline_button.dart';
import '../../../../core/widgets/dropdowns/supplier_dropdown.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../../../../core/widgets/preview_picked_image_dialog.dart';
import '../cubit/create_purchase_note/create_purchase_note_cubit.dart';
import '../widgets/purchase_note_item_card.dart';
import '../widgets/purchase_note_item_dialog.dart';

class CreatePurchaseNotePage extends StatefulWidget {
  const CreatePurchaseNotePage({super.key});

  @override
  State<CreatePurchaseNotePage> createState() => _CreatePurchaseNotePageState();
}

class _CreatePurchaseNotePageState extends State<CreatePurchaseNotePage> {
  late final TextEditingController _supplierController;
  late final TextEditingController _dateController;
  late final TextEditingController _noteController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
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
    final createPurchaseNoteCubit = context.read<CreatePurchaseNoteCubit>();
    final textTheme = context.textTheme;

    return BlocListener<CreatePurchaseNoteCubit, CreatePurchaseNoteState>(
      listenWhen: (previous, current) => current.shouldListen(previous),
      listener: (context, state) {
        if (state.supplier != null) {
          _supplierController.text = state.supplier!.value;
        }

        if (state.date != null) {
          _dateController.text = state.date!.toDMY;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Nota')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const .all(16),
            children: [
              Text('Pilih Supplier', style: textTheme.bodyLarge),
              const Gap(4),
              TextFormField(
                onTap: () => showModalBottomSheet(
                  builder: (context) => SupplierDropdown(
                    onTap: (supplier) {
                      createPurchaseNoteCubit.supplier = supplier;
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
              const Gap(12),
              Text('Tanggal', style: textTheme.bodyLarge),
              const Gap(4),
              TextFormField(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: DateTime.now(),
                    lastDate: DateTime.now(),
                    locale: const Locale('id', 'ID'),
                  );

                  createPurchaseNoteCubit.date = pickedDate;
                },
                autovalidateMode: .onUserInteraction,
                controller: _dateController,
                decoration: const InputDecoration(
                  hintText: 'Tanggal',
                  suffixIcon: Icon(Icons.date_range),
                ),
                readOnly: true,
                validator: nullValidator,
              ),
              const Gap(12),
              Text('Unggah Gambar Nota', style: textTheme.bodyLarge),
              const Gap(4),
              Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    child: PrimaryButton(
                      onPressed: () => showModalBottomSheet(
                        builder: (context) => ImagePickerBottomSheet(
                          onPicked: (image) =>
                              createPurchaseNoteCubit.image = image,
                        ),
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: .vertical(top: .circular(16)),
                        ),
                      ),
                      child: const Text('Ambil Gambar'),
                    ),
                  ),
                  BlocSelector<
                    CreatePurchaseNoteCubit,
                    CreatePurchaseNoteState,
                    File?
                  >(
                    selector: (state) => state.image,
                    builder: (context, image) {
                      if (image == null) return const SizedBox();

                      return SizedBox(
                        width: 150,
                        child: PrimaryOutlineButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => PreviewPickedImageDialog(
                              pickedImagePath: image.path,
                            ),
                          ),
                          child: const Text('Preview Gambar'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Gap(12),
              Text('Catatan', style: textTheme.bodyLarge),
              const Gap(4),
              TextFormField(
                onChanged: (value) => createPurchaseNoteCubit.note = value,
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan catatan jika ada',
                ),
                maxLines: 3,
              ),
              const Gap(24),
              const Divider(height: 1),
              const Gap(24),
              PrimaryOutlineButton(
                onPressed: () => showDialog(
                  builder: (context) => PurchaseNoteItemDialog(
                    onSave: (item) {
                      createPurchaseNoteCubit.items = [
                        ...createPurchaseNoteCubit.state.items,
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
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.primary,
                    .srcIn,
                  ),
                ),
                child: const Text('Tambah Barang'),
              ),
              const Gap(12),
              BlocBuilder<CreatePurchaseNoteCubit, CreatePurchaseNoteState>(
                builder: (context, state) {
                  return ListView.separated(
                    itemBuilder: (context, index) => PurchaseNoteItemCard(
                      onDelete: () =>
                          createPurchaseNoteCubit.removeItemAt(index),
                      onEdit: () => showDialog(
                        context: context,
                        builder: (context) => PurchaseNoteItemDialog(
                          onSave: (edited) {
                            createPurchaseNoteCubit.updateItemAt(index, edited);
                            context.pop();
                          },
                          title: 'Edit Barang',
                          initialItem: state.items[index],
                        ),
                      ),
                      warehouseItem: state.items[index],
                    ),
                    separatorBuilder: (context, index) => const Gap(12),
                    itemCount: state.items.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  );
                },
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

    return BlocConsumer<CreatePurchaseNoteCubit, CreatePurchaseNoteState>(
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

            context.read<CreatePurchaseNoteCubit>().createPurchaseNote();
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
