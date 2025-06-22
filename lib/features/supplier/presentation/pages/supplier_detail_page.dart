import 'package:flutter/material.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/themes/colors.dart';

class SupplierDetailPage extends StatelessWidget {
  const SupplierDetailPage({
    super.key,
    required this.supplierId,
  });

  final String supplierId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Detail Supplier')),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: cardBoxShadow,
            color: MaterialColors.onPrimary,
          ),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage('supplierDetail.avatarUrl'),
                radius: 50,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nama',
                ),
                initialValue: 'Dimas',
                readOnly: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                initialValue: 'dimas@gmail.com',
                readOnly: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Telepon',
                ),
                initialValue: '087826474787',
                readOnly: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Alamat',
                ),
                initialValue: 'Kapling',
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
