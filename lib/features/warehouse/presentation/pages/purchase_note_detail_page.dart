import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/confirmation_input_dialog.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/primary_outline_button.dart';
import '../../../../core/widgets/read_only_field.dart';
import '../../data/models/warehouse_item_model.dart';
import '../../domain/entities/insert_purchase_note_manual_entity.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../cubit/warehouse_cubit.dart';
import '../widgets/edit_purchase_note_item_dialog.dart';
import '../widgets/purchase_note_item_card.dart';

class PurchaseNoteDetailPage extends StatefulWidget {
  const PurchaseNoteDetailPage({
    super.key,
    required this.purchaseNoteId,
  });

  final String purchaseNoteId;

  @override
  State<PurchaseNoteDetailPage> createState() => _PurchaseNoteDetailPageState();
}

class _PurchaseNoteDetailPageState extends State<PurchaseNoteDetailPage> {
  late PurchaseNoteDetailEntity _purchaseNoteDetail;
  late final WarehouseCubit _warehouseCubit;
  late final ImagePicker _imagePicker;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _warehouseCubit = context.read<WarehouseCubit>()
      ..fetchPurchaseNote(purchaseNoteId: widget.purchaseNoteId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textFormFieldConfig = TextFormFieldConfig(
      decoration: const InputDecoration(
        labelText: 'Nominal Refund',
        prefixText: 'Rp. ',
      ),
      keyboardType: TextInputType.number,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Nota'),
      ),
      body: BlocBuilder<WarehouseCubit, WarehouseState>(
        bloc: _warehouseCubit,
        buildWhen: (previous, current) => current is FetchPurchaseNote,
        builder: (context, state) {
          if (state is FetchPurchaseNoteLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is FetchPurchaseNoteLoaded) {
            _purchaseNoteDetail = state.purchaseNote;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                ReadOnlyField(
                  title: 'Supplier',
                  value: _purchaseNoteDetail.supplier.name,
                ),
                const SizedBox(height: 12),
                ReadOnlyField(
                  title: 'Tanggal',
                  value: dMyFormat.format(_purchaseNoteDetail.date),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gambar Nota',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                // Receipt Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _pickedImage == null
                      ? Image.network(
                          _purchaseNoteDetail.receipt,
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
                          File(_pickedImage!.path),
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 4),
                PrimaryButton(
                  onPressed: () async {
                    final pickedImage = await _imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (pickedImage == null) return;

                    setState(() => _pickedImage = pickedImage);
                  },
                  child: const Text('Ganti Gambar'),
                ),
                const SizedBox(height: 12),
                ReadOnlyField(
                  maxLines: 3,
                  title: 'Catatan',
                  value: _purchaseNoteDetail.note,
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
                        '${_purchaseNoteDetail.items.length} item',
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
                    isEditable: _purchaseNoteDetail.isEditable,
                    onDelete: () => setState(
                        () => _purchaseNoteDetail.items.removeAt(index)),
                    onEdit: () => showDialog(
                      context: context,
                      builder: (context) => EditPurchaseNoteItemDialog(
                        onTap: (edited) {
                          setState(() => _purchaseNoteDetail.items[index] =
                              WarehouseItemModel.fromEntity(edited));
                          context.pop();
                        },
                        warehouseItemEntity: _purchaseNoteDetail.items[index],
                      ),
                    ),
                    warehouseItem: _purchaseNoteDetail.items[index],
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: _purchaseNoteDetail.items.length,
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
      floatingActionButton: BlocBuilder<WarehouseCubit, WarehouseState>(
        buildWhen: (previous, current) => current is FetchPurchaseNote,
        builder: (context, state) {
          if (state is FetchPurchaseNoteLoaded) {
            final totalPrice = _purchaseNoteDetail.items
                .fold(0, (prev, e) => prev + e.price * e.quantity);

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
                              '- ${idrCurrencyFormat.format(_purchaseNoteDetail.returnCost)}',
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
                              idrCurrencyFormat.format(
                                  totalPrice - _purchaseNoteDetail.returnCost),
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
                              builder: (context, state) {
                                if (state is InsertReturnCostLoading) {
                                  return ConfirmationInputDialog(
                                    actionText: 'Ya',
                                    body: 'Masukkan nominal pengembalian uang',
                                    textFormFieldConfig: textFormFieldConfig,
                                    title: 'Refund',
                                  );
                                }

                                return ConfirmationInputDialog(
                                  onAction: (value) async {
                                    final amount = int.parse(value);
                                    await _warehouseCubit.insertReturnCost(
                                        purchaseNoteId: widget.purchaseNoteId,
                                        amount: amount);
                                    setState(() => _purchaseNoteDetail
                                        .returnCost = amount);
                                  },
                                  actionText: 'Ya',
                                  body: 'Masukkan nominal pengembalian uang',
                                  textFormFieldConfig: textFormFieldConfig,
                                  title: 'Refund',
                                );
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
                              TopSnackbar.successSnackbar(
                                  message: state.message);
                            }

                            if (state is UpdatePurchaseNoteError) {
                              TopSnackbar.dangerSnackbar(
                                  message: state.message);
                            }
                          },
                          buildWhen: (previous, current) =>
                              current is UpdatePurchaseNote,
                          builder: (context, state) {
                            if (state is UpdatePurchaseNoteLoading) {
                              return const PrimaryButton(
                                child: Text('Simpan'),
                              );
                            }

                            return PrimaryButton(
                              onPressed: () async {
                                final purchaseNote =
                                    InsertPurchaseNoteManualEntity(
                                  date: _purchaseNoteDetail.date,
                                  receipt: _pickedImage?.path ??
                                      _purchaseNoteDetail.receipt,
                                  note: _purchaseNoteDetail.note,
                                  supplierId: _purchaseNoteDetail.supplier.id!,
                                  items: _purchaseNoteDetail.items,
                                );
                                await _warehouseCubit.updatePurchaseNote(
                                  purchaseNoteId: _purchaseNoteDetail.id,
                                  purchaseNote: purchaseNote,
                                );
                              },
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
