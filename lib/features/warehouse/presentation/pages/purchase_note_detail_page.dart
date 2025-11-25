import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/primary_outline_button.dart';
import '../../../../core/widgets/confirmation_input_dialog.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../../../../core/widgets/read_only_field.dart';
import '../cubit/warehouse_cubit.dart';
import '../widgets/edit_purchase_note_item_dialog.dart';
import '../widgets/purchase_note_item_card.dart';

class PurchaseNoteDetailPage extends StatelessWidget {
  const PurchaseNoteDetailPage({
    super.key,
    required this.purchaseNoteId,
  });

  final String purchaseNoteId;

  @override
  Widget build(BuildContext context) {
    final warehouseCubit = context.read<WarehouseCubit>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Nota'),
      ),
      body: BlocBuilder<WarehouseCubit, WarehouseState>(
        bloc: warehouseCubit..fetchPurchaseNote(purchaseNoteId: purchaseNoteId),
        buildWhen: (previous, current) => current is FetchPurchaseNote,
        builder: (context, state) {
          if (state is FetchPurchaseNoteLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is FetchPurchaseNoteLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                ReadOnlyField(
                  title: 'Supplier',
                  value: state.purchaseNote.supplier.name,
                ),
                const SizedBox(height: 12),
                ReadOnlyField(
                  title: 'Tanggal',
                  value: dMyFormat.format(state.purchaseNote.date),
                ),
                const SizedBox(height: 12),
                _PurchaseNoteReceiptImage(
                  receipt: state.purchaseNote.receipt,
                  pickedImage: state.pickedImage,
                ),
                const SizedBox(height: 12),
                ReadOnlyField(
                  maxLines: 3,
                  title: 'Catatan',
                  value: state.purchaseNote.note,
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                // List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Daftar Barang',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.primaryNormal.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${state.purchaseNote.items.length} item',
                        style: textTheme.bodySmall?.copyWith(
                          color: CustomColors.primaryNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // List Items
                ListView.separated(
                  itemBuilder: (context, index) => PurchaseNoteItemCard(
                    isEditable: state.purchaseNote.isEditable,
                    onDelete: () =>
                        warehouseCubit.deletePurchaseNoteItem(index),
                    onEdit: () => showDialog(
                      context: context,
                      builder: (context) => EditPurchaseNoteItemDialog(
                        onTap: (edited) {
                          warehouseCubit.editPurchaseNoteItem(index, edited);
                          context.pop();
                        },
                        warehouseItemEntity: state.purchaseNote.items[index],
                      ),
                    ),
                    warehouseItem: state.purchaseNote.items[index],
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: state.purchaseNote.items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                const SizedBox(height: 144),
              ],
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: const _PurchaseNoteSummaryAndActions(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}

class _PurchaseNoteReceiptImage extends StatelessWidget {
  const _PurchaseNoteReceiptImage({
    required this.receipt,
    this.pickedImage,
  });

  final String receipt;
  final File? pickedImage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final warehouseCubit = context.read<WarehouseCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Gambar Nota',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: pickedImage == null
              ? Image.network(
                  receipt,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    alignment: Alignment.center,
                    color: Colors.grey.shade200,
                    height: 400,
                    width: double.infinity,
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                  ),
                )
              : Image.file(
                  File(pickedImage!.path),
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 4),
        PrimaryButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) => ImagePickerBottomSheet(
              onCameraPick: () async => await warehouseCubit
                  .pickNewPurchaseNoteImage(PickImageSource.camera),
              onGalleryPick: () async => await warehouseCubit
                  .pickNewPurchaseNoteImage(PickImageSource.gallery),
            ),
          ),
          child: const Text('Ganti Gambar'),
        ),
      ],
    );
  }
}

class _PurchaseNoteSummaryAndActions extends StatelessWidget {
  const _PurchaseNoteSummaryAndActions();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final warehouseCubit = context.read<WarehouseCubit>();

    return BlocBuilder<WarehouseCubit, WarehouseState>(
      buildWhen: (previous, current) => current is FetchPurchaseNote,
      builder: (context, state) {
        if (state is FetchPurchaseNoteLoaded) {
          final totalPrice = state.purchaseNote.items
              .fold(0.0, (prev, e) => prev + e.price * e.quantity);

          return FABContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Refund',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '- ${idrCurrencyFormat.format(state.purchaseNote.returnCost)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: MaterialColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total Bersih',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            (totalPrice - state.purchaseNote.returnCost)
                                .toIDRCurrency,
                            style: textTheme.bodyLarge?.copyWith(
                              color: CustomColors.primaryNormal,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    // Refund Button
                    Expanded(
                      child: PrimaryOutlineButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) =>
                              BlocConsumer<WarehouseCubit, WarehouseState>(
                            buildWhen: (previous, current) =>
                                current is InsertReturnCost,
                            listener: (context, state) {
                              if (state is InsertReturnCostLoaded) {
                                TopSnackbar.successSnackbar(
                                    message: state.message);
                                context.pop();
                              }

                              if (state is InsertReturnCostError) {
                                TopSnackbar.dangerSnackbar(
                                    message: state.message);
                              }
                            },
                            builder: (context, insertState) {
                              final onAction = switch (insertState) {
                                InsertReturnCostLoading() => null,
                                _ => (String value) async =>
                                    await warehouseCubit
                                        .updatePurchaseNoteReturnCost(
                                            int.parse(value)),
                              };

                              return _buildInsertReturnCostDialog(
                                  onAction: onAction);
                            },
                          ),
                        ),
                        height: 40,
                        child: Text(
                          'Refund',
                          style: textTheme.bodyMedium?.copyWith(
                            color: CustomColors.primaryNormal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Save Button
                    Expanded(
                      child: BlocConsumer<WarehouseCubit, WarehouseState>(
                        listener: (context, state) {
                          if (state is UpdatePurchaseNoteLoaded) {
                            TopSnackbar.successSnackbar(message: state.message);
                          }

                          if (state is UpdatePurchaseNoteError) {
                            TopSnackbar.dangerSnackbar(message: state.message);
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is UpdatePurchaseNote,
                        builder: (context, updateState) {
                          final onPressed = switch (updateState) {
                            UpdatePurchaseNoteLoading() => null,
                            _ => () async {
                                await warehouseCubit.updatePurchaseNote(
                                  purchaseNoteId: state.purchaseNote.id,
                                  date: state.purchaseNote.date,
                                  receipt: state.pickedImage?.path ??
                                      state.purchaseNote.receipt,
                                  note: state.purchaseNote.note,
                                  supplierId: state.purchaseNote.supplier.id,
                                  items: state.purchaseNote.items,
                                );
                              },
                          };

                          return PrimaryButton(
                            onPressed: onPressed,
                            child: const Text('Simpan'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildInsertReturnCostDialog({void Function(String value)? onAction}) {
    final textFormFieldConfig = TextFormFieldConfig(
      onFieldSubmitted: onAction,
      decoration: const InputDecoration(
        labelText: 'Nominal Refund',
        prefixText: 'Rp. ',
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.send,
    );

    return ConfirmationInputDialog(
      onAction: onAction,
      actionText: 'Ya',
      body: 'Masukkan nominal pengembalian uang',
      textFormFieldConfig: textFormFieldConfig,
      title: 'Refund',
    );
  }
}
