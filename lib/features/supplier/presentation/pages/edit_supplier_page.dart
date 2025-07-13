import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/shadows.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../cubit/supplier_cubit.dart';

class EditSupplierPage extends StatefulWidget {
  const EditSupplierPage({
    super.key,
    required this.supplierId,
  });

  final String supplierId;

  @override
  State<EditSupplierPage> createState() => _EditSupplierPageState();
}

class _EditSupplierPageState extends State<EditSupplierPage> {
  late final SupplierCubit _supplierCubit;
  late final ImagePicker _imagePicker;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final GlobalKey<FormState> _formKey;
  late String _avatarUrl;
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
    _supplierCubit.fetchSupplier(supplierId: widget.supplierId);
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
      appBar: AppBar(title: const Text('Sunting Supplier')),
      body: Center(
        child: BlocBuilder<SupplierCubit, SupplierState>(
          buildWhen: (previous, current) => current is FetchSupplier,
          builder: (context, state) {
            if (state is FetchSupplierLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is FetchSupplierLoaded) {
              _nameController.text = state.supplierDetail.name;
              _emailController.text = state.supplierDetail.email;
              _phoneController.text = state.supplierDetail.phoneNumber;
              _addressController.text = state.supplierDetail.address;
              _avatarUrl = state.supplierDetail.avatarUrl;

              return Container(
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
                              ? NetworkImage(state.supplierDetail.avatarUrl)
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
                          if (state is UpdateSupplierLoaded) {
                            scaffoldMessengerKey.currentState
                                ?.showSnackBar(successSnackbar(state.message));
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is UpdateSupplier,
                        builder: (context, state) {
                          if (state is UpdateSupplierLoading) {
                            return const PrimaryButton(child: Text('Simpan'));
                          }

                          return PrimaryButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;

                              final supplierDetail = SupplierDetailEntity(
                                address: _addressController.text,
                                avatarUrl: _pickedImage?.path ?? _avatarUrl,
                                email: _emailController.text,
                                name: _nameController.text,
                                phoneNumber: _phoneController.text,
                              );

                              _supplierCubit.updateSupplier(
                                  supplierDetailEntity: supplierDetail);
                            },
                            child: const Text('Simpan'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
