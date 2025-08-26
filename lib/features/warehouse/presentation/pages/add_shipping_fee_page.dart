import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/dropdowns/purchase_note_dropdown.dart';
import '../../../../core/widgets/fab_container.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/warehouse_cubit.dart';
import '../widgets/selected_purchase_note_item.dart';

class AddShippingFeePage extends StatefulWidget {
  const AddShippingFeePage({
    super.key,
  });

  @override
  State<AddShippingFeePage> createState() => _AddShippingFeePageState();
}

class _AddShippingFeePageState extends State<AddShippingFeePage> {
  late final FocusNode _focusNode;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _shippingFeeController;
  late final WarehouseCubit _warehouseCubit;
  final _selectedPurchaseNote = <DropdownEntity>[];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusScope.of(context, createDependency: false);
    _formKey = GlobalKey<FormState>();
    _shippingFeeController = TextEditingController();
    _warehouseCubit = context.read<WarehouseCubit>();
  }

  @override
  void dispose() {
    _shippingFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Ongkos Kirim'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              onTapOutside: (event) => _focusNode.unfocus(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _shippingFeeController,
              decoration: InputDecoration(
                labelText: 'Harga Ongkos Kirim',
              ),
              keyboardType: TextInputType.number,
              validator: nullValidator,
            ),
            const SizedBox(height: 24),
            TextFormField(
              onTap: () => showModalBottomSheet(
                builder: (context) => PurchaseNoteDropdown(
                  onTap: (purchaseNote) {
                    final isSelected = _selectedPurchaseNote
                        .any((e) => e.key == purchaseNote.key);
                    if (isSelected) {
                      const message = 'Nota sudah dipilih';
                      return TopSnackbar.dangerSnackbar(message: message);
                    }
                    setState(() => _selectedPurchaseNote.add(purchaseNote));
                    context.pop();
                  },
                ),
                constraints: const BoxConstraints(minHeight: 400),
                context: context,
                isScrollControlled: true,
              ),
              onTapOutside: (event) => _focusNode.unfocus(),
              decoration: InputDecoration(
                hintText: 'Pilih Nota',
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            if (_selectedPurchaseNote.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              ListView.separated(
                itemBuilder: (context, index) => SelectedPurchaseNoteItem(
                  onDelete: () =>
                      setState(() => _selectedPurchaseNote.removeAt(index)),
                  title: _selectedPurchaseNote[index].value,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: _selectedPurchaseNote.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FABContainer(
        child: SizedBox(
          width: double.infinity,
          child: BlocConsumer<WarehouseCubit, WarehouseState>(
            buildWhen: (previous, current) => current is InsertShippingFee,
            listenWhen: (previous, current) => current is InsertShippingFee,
            listener: (context, state) {
              if (state is InsertShippingFeeLoaded) {
                TopSnackbar.successSnackbar(message: state.message);
                context.pop();
                _warehouseCubit.fetchPurchaseNotes();
              }

              if (state is InsertShippingFeeError) {
                TopSnackbar.dangerSnackbar(message: state.message);
              }
            },
            builder: (context, state) {
              if (state is InsertShippingFeeLoading) {
                return const PrimaryButton(child: Text('Simpan'));
              }

              return PrimaryButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (_selectedPurchaseNote.isEmpty) {
                    const message = 'Pilih minimal 1 nota';
                    return TopSnackbar.dangerSnackbar(message: message);
                  }

                  _warehouseCubit.insertShippingFee(
                    price: int.parse(_shippingFeeController.text),
                    purchaseNoteIds:
                        _selectedPurchaseNote.map((e) => e.key).toList(),
                  );
                },
                child: const Text('Simpan'),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
