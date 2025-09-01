import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../cubit/supplier_cubit.dart';

class AddSupplierPage extends StatefulWidget {
  const AddSupplierPage({super.key});

  @override
  State<AddSupplierPage> createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  late final SupplierCubit _supplierCubit;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final GlobalKey<FormState> _formKey;
  XFile? _pickedImage;

  @override
  initState() {
    super.initState();
    _supplierCubit = context.read<SupplierCubit>();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Supplier'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: cardBoxShadow,
            color: MaterialColors.surfaceContainerLowest,
          ),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                // Avatar
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    builder: (context) => ImagePickerBottomSheet(
                      onPicked: (image) => setState(() => _pickedImage = image),
                    ),
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  ),
                  child: UnconstrainedBox(
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          foregroundImage: _pickedImage != null
                              ? FileImage(File(_pickedImage!.path))
                              : null,
                          child: _pickedImage == null
                              ? Icon(
                                  Icons.person_outline,
                                  color: Colors.grey.shade400,
                                  size: 50,
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: CustomColors.primaryNormal,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.edit,
                              color: MaterialColors.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: nullValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.isEmpty
                      ? null
                      : emailValidator(value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Telepon',
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: nullValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _addressController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Alamat',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                BlocConsumer<SupplierCubit, SupplierState>(
                  buildWhen: (previous, current) => current is InsertSupplier,
                  listener: (context, state) {
                    if (state is InsertSupplierError) {
                      TopSnackbar.dangerSnackbar(message: state.message);
                    }

                    if (state is InsertSupplierLoaded) {
                      TopSnackbar.successSnackbar(message: state.message);
                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    if (state is InsertSupplierLoading) {
                      return const PrimaryButton(
                        child: Text('Simpan'),
                      );
                    }

                    return PrimaryButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        final supplierDetail = SupplierDetailEntity(
                          address: _addressController.text,
                          avatarUrl: _pickedImage?.path,
                          email: _emailController.text,
                          name: _nameController.text,
                          phoneNumber: _phoneController.text,
                        );

                        _supplierCubit.insertSupplier(
                            supplierDetailEntity: supplierDetail);
                      },
                      child: const Text('Simpan'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
