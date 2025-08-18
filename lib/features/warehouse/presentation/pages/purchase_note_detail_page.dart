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
                Text(
                  'Supplier',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  initialValue: purchaseNoteDetail.supplier.name,
                  readOnly: true,
                ),
                const SizedBox(height: 12),
                Text(
                  'Tanggal',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  initialValue: dMyFormat.format(purchaseNoteDetail.date),
                  readOnly: true,
                ),
                const SizedBox(height: 12),
                Text(
                  'Gambar Nota',
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Image.network(
                  purchaseNoteDetail.receipt,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Jumlah Barang',
                        style: textTheme.bodyLarge,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          ' ${purchaseNoteDetail.items.length}',
                          style: textTheme.titleLarge?.copyWith(
                            color: CustomColors.primaryNormal,
                            fontWeight: FontWeight.w600,
                          ),
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
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  initialValue: purchaseNoteDetail.note,
                  maxLines: 3,
                  readOnly: true,
                ),
                const SizedBox(height: 24),
                Divider(),
                const SizedBox(height: 24),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total biaya refund',
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          idrCurrencyFormat
                              .format(purchaseNoteDetail.returnCost),
                          style: textTheme.bodyLarge?.copyWith(
                            color: MaterialColors.error,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total semua harga',
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          idrCurrencyFormat.format(
                              purchaseNoteDetail.totalPrice -
                                  purchaseNoteDetail.returnCost),
                          style: textTheme.bodyLarge?.copyWith(
                            color: CustomColors.primaryNormal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                            child: const Text('Refund'),
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
                                return const PrimaryButton(
                                  child: Text('Simpan'),
                                );
                              }

                              return PrimaryButton(
                                onPressed: () async {
                                  await warehouseCubit.insertReturnCost(
                                      purchaseNoteId: purchaseNoteId,
                                      amount: purchaseNoteDetail.returnCost);
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
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
