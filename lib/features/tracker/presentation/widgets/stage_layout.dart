import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/shipment_entity.dart';
import '../cubit/shipment_cubit.dart';
import 'action_button.dart';
import 'delete_data_alert_dialog.dart';
import 'expandable_fab.dart';
import 'insert_data_from_scanner_alert_dialog.dart';

class StageLayout extends StatefulWidget {
  const StageLayout({
    super.key,
    required this.appBarTitle,
    required this.stage,
  });

  final String appBarTitle;
  final String stage;

  @override
  State<StageLayout> createState() => _StageLayoutState();
}

class _StageLayoutState extends State<StageLayout> {
  final _controller = TextEditingController();
  late String dMyDate;
  late String date;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    date = dateFormat.format(DateTime.now());
    dMyDate = dMyFormat.format(DateTime.now());
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer();
    final shipmentCubit = context.read<ShipmentCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return BlocListener<ShipmentCubit, ShipmentState>(
      listener: (context, state) async {
        if (state is InsertShipmentLoaded) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            successSnackbar(
              state.message,
              EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.sizeOf(context).height - 175,
              ),
            ),
          );
          await audioPlayer.play(AssetSource(successSound));
          await shipmentCubit.fetchShipments(
            date: dateFormat.format(DateTime.now()),
            stage: widget.stage,
          );
        }
      },
      child: Scaffold(
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
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();

                      void callback() => shipmentCubit.searchShipments(
                          date: date,
                          stage: widget.stage,
                          keyword: value.trim());

                      _debounce = Timer(
                        const Duration(milliseconds: 500),
                        callback,
                      );
                    },
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Cari Resi',
                      suffixIcon: Icon(Icons.search),
                    ),
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
                            locale: const Locale('id'),
                          );

                          if (datePicked == null) return;

                          setState(() {
                            dMyDate = dMyFormat.format(datePicked);
                            date = dateFormat.format(datePicked);
                          });

                          await shipmentCubit.fetchShipments(
                            date: date,
                            stage: widget.stage,
                          );
                        },
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          dMyDate,
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
            Expanded(
              child: BlocBuilder<ShipmentCubit, ShipmentState>(
                bloc: shipmentCubit
                  ..fetchShipments(date: date, stage: widget.stage),
                buildWhen: (previous, current) => current is FetchShipments,
                builder: (context, state) {
                  if (state is FetchShipmentsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is FetchShipmentsLoaded) {
                    if (shipmentCubit.shipments.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum Ada Data',
                          style: textTheme.titleLarge,
                        ),
                      );
                    }

                    return _buildListItemWrapper(
                      itemBuilder: (context, index) {
                        if (index != shipmentCubit.shipments.length) {
                          final shipment = state.shipments[index];
                          return _buildListItem(shipment: shipment);
                        }

                        if (!shipmentCubit.isEndPage) {
                          shipmentCubit.fetchShipmentsPaginate(
                            date: date,
                            stage: widget.stage,
                          );

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return const SizedBox();
                      },
                      itemCount: state.shipments.length + 1,
                    );
                  }

                  if (state is SearchShipmentsLoaded) {
                    return _buildListItemWrapper(
                      itemBuilder: (context, index) =>
                          _buildListItem(shipment: state.shipments[index]),
                      itemCount: state.shipments.length,
                    );
                  }

                  if (state is FetchShipmentsError) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () => shipmentCubit.fetchShipments(
                            date: dateFormat.format(DateTime.now()),
                            stage: widget.stage),
                        child: const Text('Muat Ulang'),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: ExpandableFAB(
          distance: 90,
          children: [
            ActionButton(
              onPressed: () async {
                final receiptCamera = await BarcodeScanner.scan();

                if (receiptCamera.rawContent.isEmpty) return;

                await shipmentCubit.insertShipment(
                    receiptNumber: receiptCamera.rawContent,
                    stage: widget.stage);
              },
              icon: Icons.document_scanner_rounded,
            ),
            ActionButton(
              onPressed: () => showDialog(
                builder: (context) =>
                    InsertDataFromScannerAlertDialog(stage: widget.stage),
                context: context,
              ),
              icon: Icons.barcode_reader,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItemWrapper({
    required Widget Function(BuildContext context, int index) itemBuilder,
    required int itemCount,
  }) {
    return ListTileTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.green,
      child: RefreshIndicator(
        displacement: 12,
        onRefresh: () async => context
            .read<ShipmentCubit>()
            .fetchShipments(date: date, stage: widget.stage),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: itemBuilder,
          itemCount: itemCount,
        ),
      ),
    );
  }

  Widget _buildListItem({required ShipmentEntity shipment}) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: () => context.push(detailReceiptRoute, extra: shipment.id),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            shipment.courier,
            style: textTheme.titleLarge,
          ),
          Text(
            dateTimeFormat.format(shipment.date),
            style: textTheme.bodyMedium,
          ),
        ],
      ),
      subtitle: Text(
        shipment.receiptNumber,
        style: textTheme.titleMedium,
      ),
      trailing: _buildDeleteButton(shipment: shipment),
    );
  }

  Widget _buildDeleteButton({required ShipmentEntity shipment}) {
    final authCubit = context.read<AuthCubit>();
    final isSuperAdmin =
        authCubit.user.permissions.contains(superAdminPermission);

    if (!isSuperAdmin) return const SizedBox();

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => DeleteDataAlertDialog(
          date: date,
          shipment: shipment,
          stage: widget.stage,
        ),
      ),
      child: const Icon(Icons.delete),
    );
  }
}
