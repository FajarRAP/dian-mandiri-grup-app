import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../cubit/supplier/new_supplier_cubit.dart';
import '../widgets/editable_avatar.dart';

class AddSupplierPage extends StatefulWidget {
  const AddSupplierPage({super.key});

  @override
  State<AddSupplierPage> createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final GlobalKey<FormState> _formKey;
  File? _pickedImage;

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
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
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Supplier')),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              boxShadow: cardBoxShadow,
              color: context.colorScheme.surfaceContainerLowest,
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
                        onPicked: (image) =>
                            setState(() => _pickedImage = image),
                      ),
                      context: context,
                    ),
                    imagePath: _pickedImage?.path,
                  ),
                  const Gap(24),
                  TextFormField(
                    autovalidateMode: .onUserInteraction,
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    textInputAction: .next,
                    validator: nullValidator,
                  ),
                  const Gap(12),
                  TextFormField(
                    autovalidateMode: .onUserInteraction,
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: .emailAddress,
                    textInputAction: .next,
                    validator: (value) => value == null || value.isEmpty
                        ? null
                        : emailValidator(value),
                  ),
                  const Gap(12),
                  TextFormField(
                    autovalidateMode: .onUserInteraction,
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Telepon'),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: .phone,

                    textInputAction: .next,
                    validator: nullValidator,
                  ),
                  const Gap(12),
                  TextFormField(
                    autovalidateMode: .onUserInteraction,
                    controller: _addressController,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Alamat',
                    ),
                    keyboardType: .multiline,
                    maxLines: 2,
                  ),
                  const Gap(24),
                  BlocConsumer<NewSupplierCubit, NewSupplierState>(
                    listener: (context, state) {
                      if (state.actionStatus == .failure) {
                        TopSnackbar.dangerSnackbar(
                          message: state.failure!.message,
                        );
                      }

                      if (state.actionStatus == .success) {
                        TopSnackbar.successSnackbar(message: state.message!);
                        context
                          ..pop()
                          ..read<NewSupplierCubit>().fetchSuppliers();
                      }
                    },
                    builder: (context, state) {
                      final onPressed = switch (state.actionStatus) {
                        .inProgress => null,
                        _ => () {
                          if (!_formKey.currentState!.validate()) return;

                          context.read<NewSupplierCubit>().createSupplier(
                            name: _nameController.text,
                            phoneNumber: _phoneController.text,
                            address: _addressController.text,
                            avatar: _pickedImage?.path,
                            email: _emailController.text,
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
        ),
      ),
    );
  }
}
