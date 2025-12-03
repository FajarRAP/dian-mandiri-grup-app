import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/presentation/widgets/error_state_widget.dart';
import '../../../../core/presentation/widgets/loading_indicator.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/presentation/widgets/buttons/primary_button.dart';
import '../../../../core/presentation/widgets/buttons/primary_outline_button.dart';
import '../../../../core/presentation/widgets/fab_container.dart';
import '../../../../core/presentation/widgets/image_picker_bottom_sheet.dart';
import '../../../../core/presentation/widgets/read_only_field.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../../domain/entities/warehouse_item_entity.dart';
import '../cubit/purchase_note_cost/purchase_note_cost_cubit.dart';
import '../cubit/purchase_note_detail/purchase_note_detail_cubit.dart';
import '../cubit/purchase_note_form/purchase_note_form_cubit.dart';
import '../widgets/purchase_note_item_card.dart';
import '../widgets/purchase_note_item_dialog.dart';
import '../widgets/update_return_cost_dialog.dart';

class PurchaseNoteDetailPage extends StatefulWidget {
  const PurchaseNoteDetailPage({super.key, required this.purchaseNoteId});

  final String purchaseNoteId;

  @override
  State<PurchaseNoteDetailPage> createState() => _PurchaseNoteDetailPageState();
}

class _PurchaseNoteDetailPageState extends State<PurchaseNoteDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PurchaseNoteDetailCubit>().fetchPurchaseNote(
      purchaseNoteId: widget.purchaseNoteId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Rincian Nota')),
        body: BlocConsumer<PurchaseNoteDetailCubit, PurchaseNoteDetailState>(
          listener: (context, state) {
            if (state.status == .success) {
              context.read<PurchaseNoteFormCubit>().initializeForEdit(
                state.purchaseNote!,
              );
            }
          },
          builder: (context, state) {
            return switch (state.status) {
              .inProgress => const LoadingIndicator(),
              .success => _SuccessWidget(purchaseNote: state.purchaseNote!),
              .failure => ErrorStateWidget(failure: state.failure),
              _ => const SizedBox(),
            };
          },
        ),
        floatingActionButton: _FAB(purchaseNoteId: widget.purchaseNoteId),
        floatingActionButtonLocation: .centerDocked,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.purchaseNote});

  final PurchaseNoteDetailEntity purchaseNote;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final purchaseNoteFormCubit = context.read<PurchaseNoteFormCubit>();
    final items = context
        .select<PurchaseNoteFormCubit, List<WarehouseItemEntity>>(
          (cubit) => cubit.state.items,
        );

    return RefreshIndicator(
      onRefresh: () async => context
          .read<PurchaseNoteDetailCubit>()
          .fetchPurchaseNote(purchaseNoteId: purchaseNote.id),
      child: ListView(
        padding: const .all(16),
        children: <Widget>[
          ReadOnlyField(title: 'Supplier', value: purchaseNote.supplier.name),
          const Gap(12),
          ReadOnlyField(title: 'Tanggal', value: purchaseNote.date.toDMY),
          const Gap(12),
          _ReceiptImage(receipt: purchaseNote.receipt),
          const Gap(12),
          ReadOnlyField(
            maxLines: 3,
            title: 'Catatan',
            value: purchaseNote.note,
          ),
          const Gap(24),
          const Divider(),
          const Gap(24),
          // List Header
          Row(
            mainAxisAlignment: .spaceBetween,
            children: <Widget>[
              Text(
                'Daftar Barang',
                style: textTheme.titleMedium?.copyWith(fontWeight: .w600),
              ),
              Container(
                padding: const .symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: .1),
                  borderRadius: .circular(16),
                ),
                child: Text(
                  '${items.length} item',
                  style: textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: .w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          // List Items
          ListView.separated(
            itemBuilder: (context, index) => PurchaseNoteItemCard(
              isEditable: purchaseNote.isEditable,
              onDelete: () => purchaseNoteFormCubit.removeItemAt(index),
              onEdit: () => showDialog(
                context: context,
                builder: (_) => PurchaseNoteItemDialog(
                  onSave: (edited) {
                    purchaseNoteFormCubit.updateItemAt(index, edited);
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          const Gap(144),
        ],
      ),
    );
  }
}

class _ReceiptImage extends StatelessWidget {
  const _ReceiptImage({required this.receipt});

  final String receipt;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return BlocSelector<PurchaseNoteFormCubit, PurchaseNoteFormState, File?>(
      selector: (state) => state.image,
      builder: (context, image) {
        return Column(
          crossAxisAlignment: .stretch,
          spacing: 4,
          children: [
            Text('Gambar Nota', style: textTheme.bodyLarge),
            ClipRRect(
              borderRadius: .circular(8),
              child: image == null
                  ? Image.network(
                      receipt,
                      height: 400,
                      width: .infinity,
                      fit: .cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        alignment: .center,
                        color: Colors.grey.shade200,
                        height: 400,
                        width: .infinity,
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    )
                  : Image.file(
                      File(image.path),
                      height: 400,
                      width: .infinity,
                      fit: .cover,
                    ),
            ),
            PrimaryButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => ImagePickerBottomSheet(
                  onPicked: (image) =>
                      context.read<PurchaseNoteFormCubit>().image = image,
                ),
              ),
              child: const Text('Ganti Gambar'),
            ),
          ],
        );
      },
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB({required this.purchaseNoteId});

  final String purchaseNoteId;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final purchaseNoteFormCubit = context.read<PurchaseNoteFormCubit>();

    return BlocConsumer<PurchaseNoteFormCubit, PurchaseNoteFormState>(
      listener: (context, state) {
        if (state.status == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
        }

        if (state.status == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        }
      },
      builder: (context, state) {
        if (!state.isEditMode) return const SizedBox();

        final onPressed = switch (state.status) {
          .inProgress => null,
          _ => purchaseNoteFormCubit.submit,
        };

        return FABContainer(
          child: Column(
            mainAxisSize: .min,
            children: <Widget>[
              Container(
                padding: const .symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: .circular(8),
                  color: context.colorScheme.surfaceContainerLow,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: <Widget>[
                        Text(
                          'Refund',
                          style: textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '- ${state.returnCost.toIDRCurrency}',
                          style: textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.error,
                            fontWeight: .w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(6),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Bersih',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: .w600,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          (state.totalAmount - state.returnCost).toIDRCurrency,
                          style: textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: .w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Row(
                children: <Widget>[
                  // Refund Button
                  Expanded(
                    child: PrimaryOutlineButton(
                      onPressed: () async {
                        final result = await showDialog<int>(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<PurchaseNoteCostCubit>(),
                            child: UpdateReturnCostDialog(
                              purchaseNoteId: purchaseNoteId,
                            ),
                          ),
                        );

                        if (result != null) {
                          purchaseNoteFormCubit.returnCost = result;
                        }
                      },
                      child: Text(
                        'Refund',
                        style: textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: .w500,
                        ),
                      ),
                    ),
                  ),
                  const Gap(8),
                  // Save Button
                  Expanded(
                    child: PrimaryButton(
                      onPressed: onPressed,
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
