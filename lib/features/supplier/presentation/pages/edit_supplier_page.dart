import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ship_tracker/core/widgets/image_picker_bottom_sheet.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
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
      appBar: AppBar(
        title: const Text('Sunting Supplier'),
      ),
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
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          builder: (context) => ImagePickerBottomSheet(
                            onPicked: (image) =>
                                setState(() => _pickedImage = image),
                          ),
                          context: context,
                          shape: RoundedRectangleBorder(
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
                                    : NetworkImage(
                                        state.supplierDetail.avatarUrl),
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
                        validator: emailValidator,
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
                          labelText: 'Alamat',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        validator: nullValidator,
                      ),
                      const SizedBox(height: 24),
                      BlocConsumer<SupplierCubit, SupplierState>(
                        listener: (context, state) {
                          if (state is UpdateSupplierError) {
                            TopSnackbar.dangerSnackbar(message: state.message);
                          }

                          if (state is UpdateSupplierLoaded) {
                            TopSnackbar.successSnackbar(message: state.message);
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is UpdateSupplier,
                        builder: (context, state) {
                          if (state is UpdateSupplierLoading) {
                            return const PrimaryButton(
                              child: Text('Simpan'),
                            );
                          }

                          return PrimaryButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;

                              final supplierDetail = SupplierDetailEntity(
                                id: widget.supplierId,
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
    );
  }
}
