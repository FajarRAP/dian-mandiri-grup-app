import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../common/constants/app_assets.dart';
import '../../../../common/constants/app_constants.dart';
import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/presentation/widgets/expandable_fab/action_button.dart';
import '../../../../core/presentation/widgets/expandable_fab/expandable_fab.dart';
import '../../../../core/presentation/widgets/pagination_listener.dart';
import '../../../../core/presentation/widgets/sliver_empty_data.dart';
import '../../../../core/presentation/widgets/sliver_loading_indicator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/shipment_entity.dart';
import '../cubit/shipment_list/shipment_list_cubit.dart';
import 'cancel_shipment_dialog.dart';
import 'create_shipment_from_scanner_dialog.dart';
import 'delete_shipment_dialog.dart';
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
  late final ShipmentListCubit _shipmentListCubit;
  late DateTime _pickedDate;

  @override
  void initState() {
    super.initState();
    _pickedDate = DateTime(2024, 10, 10);
    _audioPlayer = AudioPlayer();
    _shipmentListCubit = context.read<ShipmentListCubit>()
      ..fetchShipments(date: _pickedDate, stage: widget.stage);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipmentListCubit, ShipmentListState>(
      listener: (context, state) async {
        if (state.actionStatus == .success) {
          await _shipmentListCubit.fetchShipments(
            date: _pickedDate,
            stage: widget.stage,
          );
        }

        if (state.actionStatus == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
          await _audioPlayer.play(AssetSource(AppAssets.successSound));
        }

        if (state.actionStatus == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);

          return switch (state.failure!.statusCode) {
            422 => await _audioPlayer.play(AssetSource(AppAssets.repeatSound)),
            423 => await _audioPlayer.play(AssetSource(AppAssets.skipSound)),
            _ => null,
          };
        }
      },
      child: Scaffold(
        body: PaginationListener(
          onPaginate: () => _shipmentListCubit.fetchShipmentsPaginate(
            date: _pickedDate,
            stage: widget.stage,
          ),
          child: RefreshIndicator(
            onRefresh: () async => await _shipmentListCubit.fetchShipments(
              date: _pickedDate,
              stage: widget.stage,
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                // AppBar
                _AppBar(
                  onDatePicked: (pickedDate) => _pickedDate = pickedDate,
                  title: widget.appBarTitle,
                  stage: widget.stage,
                ),
                // List
                BlocBuilder<ShipmentListCubit, ShipmentListState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return switch (state.status) {
                      .inProgress => const SliverLoadingIndicator(),
                      .success when state.shipments.isEmpty =>
                        const SliverEmptyData(),
                      .success => _SuccessWidget(shipments: state.shipments),
                      _ => const SliverToBoxAdapter(),
                    };
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _FAB(stage: widget.stage),
      ),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    required this.onDatePicked,
    required this.title,
    required this.stage,
  });

  final void Function(DateTime pickedDate) onDatePicked;
  final String title;
  final String stage;

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  late final Debouncer _debouncer;
  late final ShipmentListCubit _shipmentCubit;
  late DateTime _pickedDate;

  @override
  void initState() {
    super.initState();
    _pickedDate = DateTime(2024, 10, 10);
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _shipmentCubit = context.read<ShipmentListCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      expandedHeight: kToolbarHeight + AppConstants.kSpaceBarHeight + 24,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Align(
          alignment: .bottomCenter,
          child: Column(
            crossAxisAlignment: .end,
            mainAxisSize: .min,
            children: <Widget>[
              Padding(
                padding: const .symmetric(horizontal: 16),
                child: TextFormField(
                  onChanged: (value) => _debouncer.run(
                    () => _shipmentCubit.fetchShipments(
                      date: _pickedDate,
                      stage: widget.stage,
                      query: value,
                    ),
                  ),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
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

                  widget.onDatePicked(datePicked);

                  await _shipmentCubit.fetchShipments(
                    date: _pickedDate,
                    stage: widget.stage,
                  );
                },
                iconAlignment: .end,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  _pickedDate.toDMY,
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontWeight: .w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      pinned: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      snap: true,
      title: Text(widget.title),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.shipments});

  final List<ShipmentEntity> shipments;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .all(16),
      sliver: SliverList.builder(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => context.pushNamed(
            Routes.trackerDetail,
            extra: shipments[index].id,
          ),
          child: ShipmentListItem(
            onCancel: () => showDialog(
              builder: (_) => BlocProvider.value(
                value: context.read<ShipmentListCubit>(),
                child: CancelShipmentDialog(
                  receiptNumber: shipments[index].receiptNumber,
                ),
              ),
              context: context,
            ),
            onDelete: () => showDialog(
              builder: (_) => BlocProvider.value(
                value: context.read<ShipmentListCubit>(),
                child: DeleteShipmentDialog(shipmentId: shipments[index].id),
              ),
              context: context,
            ),
            shipment: shipments[index],
          ),
        ),
        itemCount: shipments.length,
      ),
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB({required this.stage});

  final String stage;

  @override
  Widget build(BuildContext context) {
    final shipmentListCubit = context.read<ShipmentListCubit>();

    return ExpandableFAB(
      distance: 90,
      children: <Widget>[
        ActionButton(
          onPressed: () async {
            final receiptCamera = await SimpleBarcodeScanner.scanBarcode(
              context,
              cameraFace: .back,
              cancelButtonText: 'Batal',
              isShowFlashIcon: true,
            );

            if (receiptCamera == null) return;

            await shipmentListCubit.createShipment(
              receiptNumber: receiptCamera,
              stage: stage,
            );
          },
          icon: Icons.document_scanner_rounded,
        ),
        ActionButton(
          onPressed: () => showDialog(
            builder: (_) => BlocProvider.value(
              value: context.read<ShipmentListCubit>(),
              child: CreateShipmentFromScannerDialog(stage: stage),
            ),
            context: context,
          ),
          icon: Icons.barcode_reader,
        ),
      ],
    );
  }
}
