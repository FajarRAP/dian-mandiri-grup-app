import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/themes/colors.dart';
import '../widgets/supplier_item.dart';

class SupplierPage extends StatelessWidget {
  const SupplierPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MaterialColors.onPrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Cari Supplier',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        title: const Text('Supplier'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => SupplierItem(),
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemCount: 10,
        padding: const EdgeInsets.all(16),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(addSupplierRoute),
        child: const Icon(Icons.add),
      ),
    );
  }
}
