import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/expanded_fab/action_button.dart';
import '../../../../core/widgets/expanded_fab/expandable_fab.dart';
import '../../../../service_container.dart';
import '../../domain/entities/shipment_entity.dart';
import '../cubit/shipment_cubit.dart';
import 'cancel_shipment_dialog.dart';
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
  late DateTime _pickedDate;
  String? _search;

  @override
  void initState() {
    super.initState();
    _pickedDate = DateTime.now();
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
    getIt.get<FlutterSecureStorage>().read(key: accessTokenKey).then(print);

    return BlocListener<ShipmentCubit, ShipmentState>(
      listener: (context, state) async {
        if (state is InsertShipmentLoaded || state is DeleteShipmentLoaded) {
          await _shipmentCubit.fetchShipments(
              date: _pickedDate, stage: widget.stage);
        }

        if (state is InsertShipmentLoaded) {
          TopSnackbar.successSnackbar(message: state.message);
          await _audioPlayer.play(AssetSource(successSound));
        }

        if (state is InsertShipmentError) {
          TopSnackbar.dangerSnackbar(message: state.failure.message);

          switch (state.failure.statusCode) {
            case 422:
              return await _audioPlayer.play(AssetSource(repeatSound));
            case 423:
              return await _audioPlayer.play(AssetSource(skipSound));
          }
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => await _shipmentCubit.fetchShipments(
              date: _pickedDate, stage: widget.stage),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollState) {
              if (scrollState is ScrollEndNotification &&
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
                              onChanged: (value) => _debouncer.run(() =>
                                  _shipmentCubit.fetchShipments(
                                      date: _pickedDate,
                                      stage: widget.stage,
                                      keyword: _search = value)),
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

                              setState(() => _pickedDate = datePicked);

                              await _shipmentCubit.fetchShipments(
                                date: _pickedDate,
                                stage: widget.stage,
                              );
                            },
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(Icons.calendar_month_outlined),
                            label: Text(
                              _pickedDate.toDMY,
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
                                builder: (context) => CancelShipmentDialog(
                                    receiptNumber:
                                        state.shipments[index].receiptNumber),
                                context: context,
                              ),
                              onDelete: () => showDialog(
                                builder: (context) => _buildOnDeleteDialog(
                                    state.shipments[index]),
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
                      return const SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
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
        floatingActionButton: ExpandableFAB(
          distance: 90,
          children: <Widget>[
            ActionButton(
              onPressed: () async {
                final receiptCamera = await SimpleBarcodeScanner.scanBarcode(
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

  // Widget _buildOnCancelDialog(ShipmentEntity shipment) {
  //   return BlocConsumer<ShipmentCubit, ShipmentState>(
  //     listenWhen: (previous, current) => current is InsertShipment,
  //     listener: (context, state) {
  //       if (state is InsertShipmentLoaded) {
  //         TopSnackbar.successSnackbar(message: state.message);
  //         context.pop();
  //       }

  //       if (state is InsertShipmentError) {
  //         TopSnackbar.dangerSnackbar(message: state.failure.message);
  //       }
  //     },
  //     builder: (context, state) {
  //       final onAction = switch (state) {
  //         InsertShipmentLoading() => null,
  //         _ => () async => await _shipmentCubit.insertShipment(
  //             receiptNumber: shipment.receiptNumber, stage: cancelStage),
  //       };

  //       return ConfirmationDialog(
  //         onAction: onAction,
  //         actionText: 'Cancel',
  //         body: 'Yakin ingin cancel resi ini?',
  //         title: 'Cancel Resi',
  //       );
  //     },
  //   );
  // }

  Widget _buildOnDeleteDialog(ShipmentEntity shipment) {
    return BlocConsumer<ShipmentCubit, ShipmentState>(
      buildWhen: (previous, current) => current is DeleteShipment,
      listenWhen: (previous, current) => current is DeleteShipment,
      listener: (context, state) {
        if (state is DeleteShipmentLoaded) {
          TopSnackbar.successSnackbar(message: state.message);
          context.pop();
        }

        if (state is DeleteShipmentError) {
          TopSnackbar.dangerSnackbar(message: state.message);
        }
      },
      builder: (context, state) {
        final onAction = switch (state) {
          DeleteShipmentLoading() => null,
          _ => () async =>
              await _shipmentCubit.deleteShipment(shipmentId: shipment.id),
        };

        return ConfirmationDialog(
          onAction: onAction,
          actionText: 'Hapus',
          body: 'Yakin ingin menghapus resi ini?',
          title: 'Hapus Resi',
        );
      },
    );
  }
}
