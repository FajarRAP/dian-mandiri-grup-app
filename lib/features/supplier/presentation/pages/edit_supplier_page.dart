import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../common/utils/shadows.dart';
import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/presentation/widgets/error_state_widget.dart';
import '../../../../core/presentation/widgets/loading_indicator.dart';
import '../../../../core/presentation/widgets/pop_result_scope.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/presentation/widgets/buttons/primary_button.dart';
import '../../../../core/presentation/widgets/image_picker_bottom_sheet.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../cubit/supplier_detail/supplier_detail_cubit.dart';
import '../cubit/update_supplier/update_supplier_cubit.dart';
import '../widgets/editable_avatar.dart';

class EditSupplierPage extends StatefulWidget {
  const EditSupplierPage({super.key, required this.supplierId});

  final String supplierId;

  @override
  State<EditSupplierPage> createState() => _EditSupplierPageState();
}

class _EditSupplierPageState extends State<EditSupplierPage> {
  var _isUpdated = false;

  @override
  Widget build(BuildContext context) {
    return PopResultScope<bool>(
      value: _isUpdated,
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Supplier')),
        body: BlocBuilder<SupplierDetailCubit, SupplierDetailState>(
          builder: (context, state) {
            return switch (state.status) {
              .inProgress => const LoadingIndicator(),
              .success => _SuccessWidget(
                onUpdateSuccess: () => setState(() => _isUpdated = true),
                supplierId: widget.supplierId,
                supplier: state.supplier!,
              ),
              .failure => ErrorStateWidget(
                onRetry: () => context
                    .read<SupplierDetailCubit>()
                    .fetchSupplier(supplierId: widget.supplierId),
                failure: state.failure,
              ),
              _ => const SizedBox(),
            };
          },
        ),
      ),
    );
  }
}

class _SuccessWidget extends StatefulWidget {
  const _SuccessWidget({
    required this.onUpdateSuccess,
    required this.supplierId,
    required this.supplier,
  });

  final void Function() onUpdateSuccess;
  final String supplierId;
  final SupplierDetailEntity supplier;

  @override
  State<_SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<_SuccessWidget> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final GlobalKey<FormState> _formKey;
  String? _avatarUrl;
  File? _pickedImage;

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier.name);
    _emailController = TextEditingController(text: widget.supplier.email);
    _phoneController = TextEditingController(text: widget.supplier.phoneNumber);
    _addressController = TextEditingController(text: widget.supplier.address);
    _avatarUrl = widget.supplier.avatarUrl;
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(20),
          boxShadow: cardBoxShadow,
          color: context.colorScheme.onPrimary,
        ),
        margin: const .all(16),
        padding: const .all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              EditableAvatar(
                onTap: () => showModalBottomSheet(
                  builder: (context) => ImagePickerBottomSheet(
                    onPicked: (image) => setState(() => _pickedImage = image),
                  ),
                  context: context,
                ),
                imagePath: _pickedImage?.path ?? _avatarUrl,
              ),
              const Gap(24),
              TextFormField(
                autovalidateMode: .onUserInteraction,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                textInputAction: .next,
                validator: Validator.nullValidator,
              ),
              const Gap(12),
              TextFormField(
                autovalidateMode: .onUserInteraction,
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: .next,
                validator: Validator.emailValidator,
              ),
              const Gap(12),
              TextFormField(
                autovalidateMode: .onUserInteraction,
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telepon'),
                keyboardType: TextInputType.phone,
                textInputAction: .next,
                validator: Validator.nullValidator,
              ),
              const Gap(12),
              TextFormField(
                autovalidateMode: .onUserInteraction,
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                validator: Validator.nullValidator,
              ),
              const Gap(24),
              BlocConsumer<UpdateSupplierCubit, UpdateSupplierState>(
                listener: (context, state) {
                  if (state.status == .failure) {
                    TopSnackbar.dangerSnackbar(message: state.failure!.message);
                  }

                  if (state.status == .success) {
                    TopSnackbar.successSnackbar(message: state.message!);
                    widget.onUpdateSuccess();
                  }
                },
                builder: (context, state) {
                  final onPressed = switch (state.status) {
                    .inProgress => null,
                    _ => () {
                      if (!_formKey.currentState!.validate()) return;

                      context.read<UpdateSupplierCubit>().updateSupplier(
                        id: widget.supplierId,
                        address: _addressController.text,
                        avatar: _pickedImage?.path ?? _avatarUrl,
                        email: _emailController.text,
                        name: _nameController.text,
                        phoneNumber: _phoneController.text,
                      );
                    },
                  };

                  return PrimaryButton(
                    onPressed: onPressed,
                    child: const Text('Simpan'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
