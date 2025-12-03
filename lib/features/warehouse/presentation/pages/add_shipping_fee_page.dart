import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/dropdowns/purchase_note_dropdown.dart';
import '../../../../core/widgets/fab_container.dart';
import '../cubit/purchase_note_cost/purchase_note_cost_cubit.dart';
import '../widgets/selected_purchase_note_item.dart';

class AddShippingFeePage extends StatefulWidget {
  const AddShippingFeePage({super.key});

  @override
  State<AddShippingFeePage> createState() => _AddShippingFeePageState();
}

class _AddShippingFeePageState extends State<AddShippingFeePage> {
  late final PurchaseNoteCostCubit _purchaseNoteCostCubit;
  late final TextEditingController _shippingFeeController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _purchaseNoteCostCubit = context.read<PurchaseNoteCostCubit>();
    _shippingFeeController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _shippingFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purchaseNotes = context
        .select<PurchaseNoteCostCubit, List<DropdownEntity>>(
          (cubit) => cubit.state.purchaseNotes,
        );

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Ongkos Kirim')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                onChanged: (value) =>
                    _purchaseNoteCostCubit.shippingFee = int.parse(value),
                autovalidateMode: .onUserInteraction,
                controller: _shippingFeeController,
                decoration: const InputDecoration(
                  labelText: 'Harga Ongkos Kirim',
                  prefixText: 'Rp. ',
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: .number,
                validator: nullValidator,
              ),
              const Gap(24),
              TextFormField(
                onTap: () => showModalBottomSheet(
                  builder: (context) => PurchaseNoteDropdown(
                    onTap: (purchaseNote) {
                      _purchaseNoteCostCubit.addPurchaseNote(purchaseNote);
                      context.pop();
                    },
                  ),
                  context: context,
                  isScrollControlled: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Pilih Nota',
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                readOnly: true,
              ),
              if (purchaseNotes.isNotEmpty) ...[
                const Gap(24),
                const Divider(height: 1),
                const Gap(24),
                ListView.separated(
                  itemBuilder: (context, index) => SelectedPurchaseNoteItem(
                    onDelete: () =>
                        _purchaseNoteCostCubit.removePurchaseNoteAt(index),
                    title: purchaseNotes[index].value,
                  ),
                  separatorBuilder: (context, index) => const Gap(12),
                  itemCount: purchaseNotes.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ],
          ),
        ),
        floatingActionButton: FABContainer(
          child: BlocConsumer<PurchaseNoteCostCubit, PurchaseNoteCostState>(
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
                _ => () async {
                  if (!_formKey.currentState!.validate()) return;

                  await _purchaseNoteCostCubit.addShippingFee();
                },
              };

              return PrimaryButton(
                onPressed: onPressed,
                child: const Text('Simpan'),
              );
            },
          ),
        ),
        floatingActionButtonLocation: .centerDocked,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
