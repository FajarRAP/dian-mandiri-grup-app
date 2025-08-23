import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_outline_button.dart';
import '../../../../core/widgets/read_only_field.dart';
import '../../domain/entities/purchase_note_detail_entity.dart';
import '../cubit/warehouse_cubit.dart';
import '../widgets/purchase_note_item_card.dart';
import '../widgets/refund_purchase_note_dialog.dart';

class PurchaseNoteDetailPage extends StatelessWidget {
  const PurchaseNoteDetailPage({
    super.key,
    required this.purchaseNoteId,
  });

  final String purchaseNoteId;

  @override
  Widget build(BuildContext context) {
    late final PurchaseNoteDetailEntity purchaseNoteDetail;
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
            purchaseNoteDetail = state.purchaseNote;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                ReadOnlyField(
                  title: 'Supplier',
                  value: purchaseNoteDetail.supplier.name,
                ),
                const SizedBox(height: 12),
                ReadOnlyField(
                  title: 'Tanggal',
                  value: dMyFormat.format(purchaseNoteDetail.date),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gambar Nota',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    purchaseNoteDetail.receipt,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                ReadOnlyField(
                  maxLines: 3,
                  title: 'Catatan',
                  value: purchaseNoteDetail.note,
                ),
                const SizedBox(height: 24),
                Divider(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        '${purchaseNoteDetail.items.length} item',
                        style: textTheme.bodySmall?.copyWith(
                          color: CustomColors.primaryNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  itemBuilder: (context, index) => PurchaseNoteItemCard(
                    warehouseItem: purchaseNoteDetail.items[index],
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: purchaseNoteDetail.items.length,
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
      floatingActionButton: StatefulBuilder(builder: (context, setState) {
        return BlocBuilder<WarehouseCubit, WarehouseState>(
          buildWhen: (previous, current) => current is FetchPurchaseNote,
          builder: (context, state) {
            if (state is FetchPurchaseNoteLoaded) {
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
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Refund',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '- ${idrCurrencyFormat.format(purchaseNoteDetail.returnCost)}',
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
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                idrCurrencyFormat.format(
                                    purchaseNoteDetail.totalPrice -
                                        purchaseNoteDetail.returnCost),
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
                        Expanded(
                          child: PrimaryOutlineButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => RefundPurchaseNoteDialog(
                                onRefund: (amount) {
                                  setState(() =>
                                      purchaseNoteDetail.returnCost = amount);
                                  context.pop();
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
                        Expanded(
                          child: BlocConsumer<WarehouseCubit, WarehouseState>(
                            listener: (context, state) {
                              if (state is InsertReturnCostLoaded) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  successSnackbar(state.message),
                                );
                              }

                              if (state is InsertReturnCostError) {
                                scaffoldMessengerKey.currentState?.showSnackBar(
                                  dangerSnackbar(state.message),
                                );
                              }
                            },
                            buildWhen: (previous, current) =>
                                current is InsertReturnCost,
                            builder: (context, state) {
                              if (state is InsertReturnCostLoading) {
                                return PrimaryButton(
                                  height: 40,
                                  child: Text(
                                    'Simpan',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }

                              return PrimaryButton(
                                onPressed: () async =>
                                    await warehouseCubit.insertReturnCost(
                                        purchaseNoteId: purchaseNoteId,
                                        amount: purchaseNoteDetail.returnCost),
                                height: 40,
                                child: Text(
                                  'Simpan',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: MaterialColors.onPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
