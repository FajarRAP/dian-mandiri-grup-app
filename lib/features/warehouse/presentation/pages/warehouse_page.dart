import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/themes/colors.dart';
import '../../../tracker/presentation/widgets/action_button.dart';
import '../../../tracker/presentation/widgets/expandable_fab.dart';
import '../widgets/purchase_note_item.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan',
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 'name,asc',
                child: const Text('Nama Naik'),
              ),
              PopupMenuItem(
                value: 'name,desc',
                child: const Text('Nama Turun'),
              ),
              PopupMenuItem(
                value: 'created_at,asc',
                child: const Text('Total Barang Naik'),
              ),
              PopupMenuItem(
                value: 'created_at,desc',
                child: const Text('Total Barang Turun'),
              ),
            ],
          ),
        ],
        backgroundColor: MaterialColors.onPrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Cari Nota',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        title: const Text('Barang Masuk'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => PurchaseNoteItem(),
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemCount: 10,
        padding: const EdgeInsets.all(16),
      ),
      floatingActionButton: ExpandableFAB(
        distance: 100,
        children: <Widget>[
          ActionButton(
            onPressed: () => context.push(addPurchaseNoteManualRoute),
            icon: Icons.add,
          ),
          ActionButton(
            onPressed: () => context.push(addPurchaseNoteFileRoute),
            icon: Icons.folder,
          ),
          ActionButton(
            onPressed: () => context.push(addShippingFeeRoute),
            icon: Icons.currency_exchange,
          ),
        ],
      ),
    );
  }
}
