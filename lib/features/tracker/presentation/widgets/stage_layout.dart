import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/courier_identifier.dart';
import '../../../../core/helpers/on_tap_scan.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/ship_entity.dart';
import '../cubit/ship_cubit.dart';
import 'action_button.dart';
import 'delete_data_alert_dialog.dart';
import 'expandable_fab.dart';

class StageLayout extends StatefulWidget {
  const StageLayout({
    super.key,
    required this.appBarTitle,
    required this.stageId,
  });

  final String appBarTitle;
  final int stageId;

  @override
  State<StageLayout> createState() => _StageLayoutState();
}

class _StageLayoutState extends State<StageLayout> {
  final _controller = TextEditingController();
  var date = DateUtils.dateOnly(DateTime.now());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipCubit = context.read<ShipCubit>();
    final dateFormat = DateFormat('d-M-y', 'id_ID');
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Cari Resi',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: shipCubit.filterShips,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: StatefulBuilder(
                    builder: (context, setState) => TextButton.icon(
                      onPressed: () async {
                        final datePicked = await showDatePicker(
                            context: context,
                            confirmText: 'Oke',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            locale: const Locale('id'));
                        if (datePicked != null) {
                          setState(() => date = datePicked);
                          shipCubit.getShips(widget.stageId, date);
                        }
                      },
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(
                        dateFormat.format(date),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<ShipCubit, ShipState>(
            bloc: shipCubit..getShips(widget.stageId, date),
            buildWhen: (previous, current) => current is GetShip,
            builder: (context, state) {
              if (state is ShipLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is ShipLoaded) {
                return ListTileTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.green,
                  child: Expanded(
                    child: RefreshIndicator(
                      displacement: 12,
                      onRefresh: () async =>
                          shipCubit.getShips(widget.stageId, date),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            shipCubit.ship = state.ships[index];
                            context.push(detailReceiptRoute);
                          },
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                courierIdentifier(state.ships[index].receipt),
                                style: textTheme.titleLarge,
                              ),
                              Text(
                                DateFormat('d-MM-y')
                                    .format(state.ships[index].syncWithWIB),
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            state.ships[index].receipt,
                            style: textTheme.titleMedium,
                          ),
                          trailing: _buildDeleteButton(state.ships[index]),
                        ),
                        itemCount: state.ships.length,
                      ),
                    ),
                  ),
                );
              }
              if (state is ShipEmpty) {
                return Expanded(
                  child: Center(
                    child: Text('Belum Ada Data', style: textTheme.titleLarge),
                  ),
                );
              }
              if (state is ShipError) {
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      floatingActionButton: ExpandableFabMine(
        distance: 90,
        children: [
          ActionButton(
            onPressed: () => onTapScan(
              context,
              widget.stageId,
              ScanType.camera,
            ),
            icon: Icons.document_scanner_rounded,
          ),
          ActionButton(
            onPressed: () => onTapScan(
              context,
              widget.stageId,
              ScanType.scannner,
            ),
            icon: Icons.barcode_reader,
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(ShipEntity ship) {
    final bool isAdmin =
        context.read<AuthCubit>().user?.userMetadata?['is_admin'] == true;

    if (!isAdmin) return const SizedBox();

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) =>
            DeleteDataAlertDialog(stageId: widget.stageId, shipId: ship.id),
      ),
      child: const Icon(Icons.delete),
    );
  }
}
