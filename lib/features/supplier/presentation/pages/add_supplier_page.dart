import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/shadows.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../cubit/supplier_cubit.dart';

class AddSupplierPage extends StatefulWidget {
  const AddSupplierPage({super.key});

  @override
  State<AddSupplierPage> createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  late final SupplierCubit _supplierCubit;
  late final ImagePicker _imagePicker;
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
    _imagePicker = ImagePicker();
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
      appBar: AppBar(title: const Text('Tambah Supplier')),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: cardBoxShadow,
            color: MaterialColors.onPrimary,
          ),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final pickedImage = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );

                    setState(() => _pickedImage = pickedImage);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _pickedImage == null
                        ? null
                        : FileImage(File(_pickedImage!.path)),
                    radius: 50,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
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
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nama',
                  ),
                  validator: nullValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Telepon',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: nullValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Alamat',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: nullValidator,
                ),
                const SizedBox(height: 24),
                BlocConsumer<SupplierCubit, SupplierState>(
                  listener: (context, state) {
                    if (state is InsertSupplierLoaded) {
                      scaffoldMessengerKey.currentState
                          ?.showSnackBar(successSnackbar(state.message));
                      _supplierCubit.fetchSuppliers();
                      context.pop();
                    }
                  },
                  buildWhen: (previous, current) => current is InsertSupplier,
                  builder: (context, state) {
                    if (state is InsertSupplierLoading) {
                      return const PrimaryButton(child: Text('Simpan'));
                    }

                    return PrimaryButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        if (_pickedImage == null) {
                          const message =
                              'Silakan pilih gambar terlebih dahulu';
                          scaffoldMessengerKey.currentState
                              ?.showSnackBar(dangerSnackbar(message));
                          return;
                        }

                        final supplierDetail = SupplierDetailEntity(
                          address: _addressController.text,
                          avatarUrl: _pickedImage!.path,
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
      resizeToAvoidBottomInset: false,
    );
  }
}
