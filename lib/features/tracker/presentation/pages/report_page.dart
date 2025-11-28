import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/widgets/pagination_listener.dart';
import '../../../../core/presentation/widgets/sliver_empty_data.dart';
import '../../../../core/presentation/widgets/sliver_loading_indicator.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/models/shipment_report_ui_model.dart';
import '../cubit/shipment_report/shipment_report_cubit.dart';
import '../widgets/create_shipment_report_dialog.dart';
import '../widgets/shipment_report_list_item.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late final ShipmentReportCubit _shipmentReportCubit;
  var _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  var _status = completedReport;

  @override
  void initState() {
    super.initState();
    _shipmentReportCubit = context.read<ShipmentReportCubit>()
      ..fetchShipmentReports(
        endDate: _dateTimeRange.end,
        startDate: _dateTimeRange.start,
        status: _status,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ShipmentReportCubit, ShipmentReportState>(
        listener: (context, state) {
          if (state.actionStatus == .success) {
            _shipmentReportCubit.fetchShipmentReports(
              endDate: _dateTimeRange.end,
              startDate: _dateTimeRange.start,
              status: _status,
            );
          }
        },
        child: PaginationListener(
          onPaginate: () => _shipmentReportCubit.fetchShipmentReportsPaginate(
            endDate: _dateTimeRange.end,
            startDate: _dateTimeRange.start,
            status: _status,
          ),
          child: RefreshIndicator.adaptive(
            onRefresh: () async =>
                await _shipmentReportCubit.fetchShipmentReports(
                  endDate: _dateTimeRange.end,
                  startDate: _dateTimeRange.start,
                  status: _status,
                ),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                // App Bar
                _AppBar(
                  onDatePicked: (dateTimeRange) =>
                      _dateTimeRange = dateTimeRange,
                  onStatusChanged: (status) => _status = status,
                ),
                // List
                BlocBuilder<ShipmentReportCubit, ShipmentReportState>(
                  buildWhen: (previous, current) =>
                      current.shouldRebuild(previous),
                  builder: (context, state) {
                    return switch (state.status) {
                      ShipmentReportStatus.inProgress =>
                        const SliverLoadingIndicator(),
                      ShipmentReportStatus.success when state.reports.isEmpty =>
                        const SliverEmptyData(),
                      ShipmentReportStatus.success => _SuccessWidget(
                        reports: state.reports,
                      ),
                      _ => const SliverToBoxAdapter(),
                    };
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({this.onDatePicked, this.onStatusChanged});

  final void Function(DateTimeRange dateTimeRange)? onDatePicked;
  final void Function(String status)? onStatusChanged;

  @override
  State<_AppBar> createState() => __AppBarState();
}

class __AppBarState extends State<_AppBar> {
  var _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  var _status = completedReport;
  var _dateTimeRangePicked = 'Pilih Range Tanggal';

  @override
  Widget build(BuildContext context) {
    final shipmentReportCubit = context.read<ShipmentReportCubit>();

    return SliverAppBar(
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (context) => <PopupMenuItem>[
            PopupMenuItem(
              onTap: () => showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<ShipmentReportCubit>(),
                  child: CreateReportDateRangeDialog(status: _status),
                ),
              ),
              child: const Text('Buat Laporan'),
            ),
          ],
        ),
      ],
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      expandedHeight: kToolbarHeight + kSpaceBarHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: Align(
          alignment: .bottomCenter,
          child: Padding(
            padding: const .all(16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () async {
                    final dateTimeRangePicked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      locale: const Locale('id'),
                    );

                    if (dateTimeRangePicked == null) return;

                    _dateTimeRange = dateTimeRangePicked;
                    final startDate = _dateTimeRange.start;
                    final endDate = _dateTimeRange.end;

                    widget.onDatePicked?.call(_dateTimeRange);

                    setState(
                      () => _dateTimeRangePicked =
                          '${startDate.toDMY} s.d.\n${endDate.toDMY}',
                    );

                    await shipmentReportCubit.fetchShipmentReports(
                      endDate: endDate,
                      startDate: startDate,
                      status: _status,
                    );
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: Text(_dateTimeRangePicked),
                ),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    onChanged: (value) {
                      if (value == null) return;

                      widget.onStatusChanged?.call(value);

                      shipmentReportCubit.fetchShipmentReports(
                        endDate: _dateTimeRange.end,
                        startDate: _dateTimeRange.start,
                        status: _status = value,
                      );
                    },
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: .w500,
                    ),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: pendingReport,
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: processingReport,
                        child: Text('Processing'),
                      ),
                      DropdownMenuItem(
                        value: completedReport,
                        child: Text('Compeleted'),
                      ),
                      DropdownMenuItem(
                        value: failedReport,
                        child: Text('Failed'),
                      ),
                    ],
                    initialValue: _status,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floating: true,
      pinned: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      snap: true,
      title: const Text('Laporan'),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  const _SuccessWidget({required this.reports});

  final List<ShipmentReportUiModel> reports;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .all(16),
      sliver: SliverList.builder(
        itemBuilder: (context, index) =>
            ShipmentReportListItem(shipmentReport: reports[index]),
        itemCount: reports.length,
      ),
    );
  }
}
