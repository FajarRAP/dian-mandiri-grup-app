import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/app_constants.dart';
import '../../../../core/presentation/widgets/pagination_listener.dart';
import '../../../../core/presentation/widgets/sliver_empty_data.dart';
import '../../../../core/presentation/widgets/sliver_error_state_widget.dart';
import '../../../../core/presentation/widgets/sliver_loading_indicator.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../service_container.dart';
import '../../data/models/shipment_report_ui_model.dart';
import '../cubit/create_shipment_report/create_shipment_report_cubit.dart';
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

  @override
  void initState() {
    super.initState();
    _shipmentReportCubit = context.read<ShipmentReportCubit>()
      ..fetchShipmentReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginationListener(
        onPaginate: _shipmentReportCubit.fetchShipmentReportsPaginate,
        child: RefreshIndicator.adaptive(
          onRefresh: _shipmentReportCubit.fetchShipmentReports,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              // App Bar
              const _AppBar(),
              // List
              BlocBuilder<ShipmentReportCubit, ShipmentReportState>(
                buildWhen: (previous, current) =>
                    current.shouldRebuild(previous),
                builder: (context, state) {
                  return switch (state.status) {
                    .inProgress => const SliverLoadingIndicator(),
                    .success when state.reports.isEmpty =>
                      const SliverEmptyData(),
                    .success => _SuccessWidget(reports: state.reports),
                    .failure => SliverErrorStateWidget(failure: state.failure),
                    _ => const SliverToBoxAdapter(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final shipmentReportCubit = context.read<ShipmentReportCubit>();
    final dateTimeRange = context.select<ShipmentReportCubit, DateTimeRange?>(
      (cubit) => cubit.state.dateTimeRange,
    );
    final status = context.select<ShipmentReportCubit, String>(
      (cubit) => cubit.state.filterStatus,
    );
    final text = dateTimeRange.isEqual
        ? '${dateTimeRange?.start.toDMY}'
        : '${dateTimeRange?.start.toDMY} - ${dateTimeRange?.end.toDMY}';

    return SliverAppBar(
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (context) => <PopupMenuItem>[
            PopupMenuItem(
              onTap: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => BlocProvider(
                    create: (context) => getIt<CreateShipmentReportCubit>(),
                    child: const CreateShipmentReportDialog(),
                  ),
                );

                if (result == true && context.mounted) {
                  await shipmentReportCubit.fetchShipmentReports();
                }
              },
              child: const Text('Buat Laporan'),
            ),
          ],
        ),
      ],
      backgroundColor: context.colorScheme.surfaceContainerLowest,
      expandedHeight: kToolbarHeight + AppConstants.kSpaceBarHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: Align(
          alignment: .bottomCenter,
          child: Padding(
            padding: const .all(16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextButton.icon(
                    onPressed: () async {
                      final dateTimeRangePicked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        locale: const Locale('id'),
                      );

                      if (dateTimeRangePicked == null || !context.mounted) {
                        return;
                      }

                      await shipmentReportCubit.fetchShipmentReports(
                        dateTimeRange: dateTimeRangePicked,
                      );
                    },

                    icon: const Icon(Icons.calendar_month_rounded),
                    label: Text(text),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    onChanged: (value) {
                      if (value == null) return;

                      shipmentReportCubit.fetchShipmentReports(status: value);
                    },
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: .w500,
                    ),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: AppConstants.pendingReport,
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: AppConstants.processingReport,
                        child: Text('Processing'),
                      ),
                      DropdownMenuItem(
                        value: AppConstants.completedReport,
                        child: Text('Compeleted'),
                      ),
                      DropdownMenuItem(
                        value: AppConstants.failedReport,
                        child: Text('Failed'),
                      ),
                    ],
                    initialValue: status,
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
