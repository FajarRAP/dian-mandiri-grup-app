import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/debouncer.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/expanded_fab/action_button.dart';
import '../../../../core/widgets/expanded_fab/expandable_fab.dart';
import '../cubit/shipment_cubit.dart';
import 'insert_shipment_from_scanner_dialog.dart';
import 'shipment_list_item.dart';

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
  late final AudioPlayer _audioPlayer;
  late final Debouncer _debouncer;
  late final FocusNode _focusNode;
  late final ShipmentCubit _shipmentCubit;
  late String _dMyDate;
  late String _pickedDate;
  String? _search;

  @override
  void initState() {
    super.initState();
    _pickedDate = dateFormat.format(DateTime.now());
    _dMyDate = dMyFormat.format(DateTime.now());
    _audioPlayer = AudioPlayer();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _focusNode = FocusScope.of(context, createDependency: false);
    _shipmentCubit = context.read<ShipmentCubit>()
      ..fetchShipments(date: _pickedDate, stage: widget.stage);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipmentCubit, ShipmentState>(
      listener: (context, state) {
        if (state is InsertShipmentLoaded || state is DeleteShipmentLoaded) {
          _shipmentCubit.fetchShipments(
            date: dateFormat.format(DateTime.now()),
            stage: widget.stage,
          );
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => await _shipmentCubit.fetchShipments(
              date: _pickedDate, stage: widget.stage),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollState) {
              if (scrollState.runtimeType == ScrollEndNotification &&
                  _shipmentCubit.state is! ListPaginateLast) {
                _shipmentCubit.fetchShipmentsPaginate(
                  date: _pickedDate,
                  stage: widget.stage,
                  keyword: _search,
                );
              }

              return false;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                // AppBar
                SliverAppBar(
                  backgroundColor: MaterialColors.surfaceContainerLowest,
                  expandedHeight: kToolbarHeight + kSpaceBarHeight + 24,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              onChanged: (value) {
                                _search = value;
                                _debouncer.run(() =>
                                    _shipmentCubit.fetchShipments(
                                        date: _pickedDate,
                                        stage: widget.stage,
                                        keyword: _search));
                              },
                              onTapOutside: (event) => _focusNode.unfocus(),
                              decoration: const InputDecoration(
                                hintText: 'Cari Resi',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          TextButton.icon(
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
                                _dMyDate = dMyFormat.format(datePicked);
                                _pickedDate = dateFormat.format(datePicked);
                              });

                              await _shipmentCubit.fetchShipments(
                                date: _pickedDate,
                                stage: widget.stage,
                              );
                            },
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(Icons.calendar_month_outlined),
                            label: Text(
                              _dMyDate,
                              style: const TextStyle(
                                color: CustomColors.primaryNormal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pinned: true,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: MaterialColors.outlineVariant,
                    ),
                  ),
                  snap: true,
                  title: Text(widget.appBarTitle),
                ),
                // List
                BlocBuilder<ShipmentCubit, ShipmentState>(
                  bloc: _shipmentCubit,
                  buildWhen: (previous, current) => current is FetchShipments,
                  builder: (context, state) {
                    if (state is FetchShipmentsLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    if (state is FetchShipmentsLoaded) {
                      if (state.shipments.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text('Belum Ada Data'),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList.builder(
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => context.push(
                              detailReceiptRoute,
                              extra: state.shipments[index].id,
                            ),
                            child: ShipmentListItem(
                              onCancel: () => showDialog(
                                builder: (context) =>
                                    BlocConsumer<ShipmentCubit, ShipmentState>(
                                  listenWhen: (previous, current) =>
                                      current is InsertShipment,
                                  listener: (context, state) {
                                    if (state is InsertShipmentLoaded) {
                                      TopSnackbar.successSnackbar(
                                          message: state.message);
                                      context.pop();
                                    }

                                    if (state is InsertShipmentError) {
                                      TopSnackbar.dangerSnackbar(
                                          message: state.failure.message);
                                    }
                                  },
                                  builder: (context, cancelState) {
                                    if (cancelState is InsertShipmentLoading) {
                                      return ConfirmationDialog(
                                        actionText: 'Cancel',
                                        body: 'Yakin ingin cancel resi ini?',
                                        title: 'Cancel Resi',
                                      );
                                    }

                                    return ConfirmationDialog(
                                      onAction: () async =>
                                          await _shipmentCubit.insertShipment(
                                        receiptNumber: state
                                            .shipments[index].receiptNumber,
                                        stage: cancelStage,
                                      ),
                                      actionText: 'Cancel',
                                      body: 'Yakin ingin cancel resi ini?',
                                      title: 'Cancel Resi',
                                    );
                                  },
                                ),
                                context: context,
                              ),
                              onDelete: () => showDialog(
                                builder: (context) =>
                                    BlocConsumer<ShipmentCubit, ShipmentState>(
                                  buildWhen: (previous, current) =>
                                      current is DeleteShipment,
                                  listenWhen: (previous, current) =>
                                      current is DeleteShipment,
                                  listener: (context, state) {
                                    if (state is DeleteShipmentLoaded) {
                                      TopSnackbar.successSnackbar(
                                          message: state.message);
                                      context.pop();
                                    }

                                    if (state is DeleteShipmentError) {
                                      TopSnackbar.dangerSnackbar(
                                          message: state.message);
                                    }
                                  },
                                  builder: (context, deleteState) {
                                    if (deleteState is DeleteShipmentLoading) {
                                      return ConfirmationDialog(
                                        actionText: 'Hapus',
                                        body: 'Yakin ingin menghapus resi ini?',
                                        title: 'Hapus Resi',
                                      );
                                    }

                                    return ConfirmationDialog(
                                      onAction: () async =>
                                          await _shipmentCubit.deleteShipment(
                                        shipmentId: state.shipments[index].id,
                                      ),
                                      actionText: 'Hapus',
                                      body: 'Yakin ingin menghapus resi ini?',
                                      title: 'Hapus Resi',
                                    );
                                  },
                                ),
                                context: context,
                              ),
                              shipment: state.shipments[index],
                            ),
                          ),
                          itemCount: state.shipments.length,
                        ),
                      );
                    }

                    return const SliverToBoxAdapter();
                  },
                ),
                // Widget when Pagination
                BlocBuilder<ShipmentCubit, ShipmentState>(
                  buildWhen: (previous, current) => current is ListPaginate,
                  builder: (context, state) {
                    if (state is ListPaginateLoading) {
                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter();
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: widget.stage == cancelStage
            ? null
            : ExpandableFAB(
                distance: 90,
                children: <Widget>[
                  BlocListener<ShipmentCubit, ShipmentState>(
                    listenWhen: (previous, current) =>
                        current is InsertShipment,
                    listener: (context, state) async {
                      if (state is InsertShipmentLoaded) {
                        TopSnackbar.successSnackbar(message: state.message);
                        await _audioPlayer.play(AssetSource(successSound));
                      }

                      if (state is InsertShipmentError) {
                        TopSnackbar.dangerSnackbar(
                            message: state.failure.message);

                        switch (state.failure.statusCode) {
                          case 422:
                            return await _audioPlayer
                                .play(AssetSource(repeatSound));
                          case 423:
                            return await _audioPlayer
                                .play(AssetSource(skipSound));
                        }
                      }
                    },
                    child: ActionButton(
                      onPressed: () async {
                        final receiptCamera =
                            await SimpleBarcodeScanner.scanBarcode(
                          context,
                          cameraFace: CameraFace.back,
                          cancelButtonText: 'Batal',
                          isShowFlashIcon: true,
                        );

                        if (receiptCamera == null) return;

                        await _shipmentCubit.insertShipment(
                          receiptNumber: receiptCamera,
                          stage: widget.stage,
                        );
                      },
                      icon: Icons.document_scanner_rounded,
                    ),
                  ),
                  ActionButton(
                    onPressed: () => showDialog(
                      builder: (context) =>
                          InsertShipmentFromScannerDialog(stage: widget.stage),
                      context: context,
                    ),
                    icon: Icons.barcode_reader,
                  ),
                ],
              ),
      ),
    );
  }
}
