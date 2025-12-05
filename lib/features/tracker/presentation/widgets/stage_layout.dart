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
import '../../../../core/presentation/widgets/sliver_error_state_widget.dart';
import '../../../../core/presentation/widgets/sliver_loading_indicator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../service_container.dart';
import '../../domain/entities/shipment_entity.dart';
import '../cubit/create_shipment/create_shipment_cubit.dart';
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
  late final ShipmentListCubit _shipmentListCubit;

  @override
  void initState() {
    super.initState();
    _shipmentListCubit = context.read<ShipmentListCubit>()
      ..fetchShipments(stage: widget.stage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginationListener(
        onPaginate: _shipmentListCubit.fetchShipmentsPaginate,
        child: RefreshIndicator(
          onRefresh: _shipmentListCubit.fetchShipments,
          child: CustomScrollView(
            slivers: <Widget>[
              // AppBar
              _AppBar(title: widget.appBarTitle, stage: widget.stage),
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
                    .failure => SliverErrorStateWidget(failure: state.failure),
                    _ => const SliverToBoxAdapter(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocProvider(
        create: (context) => getIt<CreateShipmentCubit>(),
        child: _FAB(stage: widget.stage),
      ),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({required this.title, required this.stage});

  final String title;
  final String stage;

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  late final Debouncer _debouncer;
  late final ShipmentListCubit _shipmentListCubit;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _shipmentListCubit = context.read<ShipmentListCubit>();
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final date = context.select<ShipmentListCubit, DateTime?>(
      (cubit) => cubit.state.date,
    )!;

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
                    () => _shipmentListCubit.fetchShipments(query: value),
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

                  await _shipmentListCubit.fetchShipments(date: datePicked);
                },
                iconAlignment: .end,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  date.toDMY,
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
            onCancel: () async {
              final result = await showDialog<bool>(
                builder: (_) => BlocProvider(
                  create: (context) => getIt<CreateShipmentCubit>(),
                  child: CancelShipmentDialog(
                    receiptNumber: shipments[index].receiptNumber,
                  ),
                ),
                context: context,
              );

              if (result == true && context.mounted) {
                await context.read<ShipmentListCubit>().fetchShipments();
              }
            },
            onDelete: () async {
              final result = await showDialog<bool>(
                builder: (_) => BlocProvider(
                  create: (context) => getIt<ShipmentListCubit>(),
                  child: DeleteShipmentDialog(shipmentId: shipments[index].id),
                ),
                context: context,
              );

              if (result == true && context.mounted) {
                await context.read<ShipmentListCubit>().fetchShipments();
              }
            },
            shipment: shipments[index],
          ),
        ),
        itemCount: shipments.length,
      ),
    );
  }
}

class _FAB extends StatefulWidget {
  const _FAB({required this.stage});

  final String stage;

  @override
  State<_FAB> createState() => _FABState();
}

class _FABState extends State<_FAB> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateShipmentCubit, CreateShipmentState>(
      listener: (context, state) async {
        if (state.status == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
          await context.read<ShipmentListCubit>().fetchShipments();
          await _audioPlayer.play(AssetSource(AppAssets.successSound));
        }

        if (state.status == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);

          return switch (state.failure!.statusCode) {
            422 => await _audioPlayer.play(AssetSource(AppAssets.repeatSound)),
            423 => await _audioPlayer.play(AssetSource(AppAssets.skipSound)),
            _ => null,
          };
        }
      },
      child: ExpandableFAB(
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

              if (receiptCamera == null || !context.mounted) return;

              await context.read<CreateShipmentCubit>().createShipment(
                receiptNumber: receiptCamera,
                stage: widget.stage,
              );
            },
            icon: Icons.document_scanner_rounded,
          ),
          ActionButton(
            onPressed: () => showDialog(
              builder: (_) => BlocProvider.value(
                value: context.read<CreateShipmentCubit>(),
                child: CreateShipmentFromScannerDialog(stage: widget.stage),
              ),
              context: context,
            ),
            icon: Icons.barcode_reader,
          ),
        ],
      ),
    );
  }
}
