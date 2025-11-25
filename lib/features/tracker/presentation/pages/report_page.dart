import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/create_report_date_range_dialog.dart';
import '../widgets/shipment_report_list_item.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late final ShipmentCubit _shipmentCubit;
  var _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  var _status = completedReport;
  var _dateTimeRangePicked = 'Pilih Range Tanggal';

  @override
  void initState() {
    super.initState();
    _shipmentCubit = context.read<ShipmentCubit>()
      ..fetchShipmentReports(
        endDate: _dateTimeRange.end,
        startDate: _dateTimeRange.start,
        status: _status,
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return RefreshIndicator(
      onRefresh: () async => await _shipmentCubit.fetchShipmentReports(
          endDate: _dateTimeRange.end,
          startDate: _dateTimeRange.start,
          status: _status),
      child: Scaffold(
        body: BlocListener<ShipmentCubit, ShipmentState>(
          listener: (context, state) {
            if (state is CreateShipmentReportLoaded) {
              _shipmentCubit.fetchShipmentReports(
                endDate: _dateTimeRange.end,
                startDate: _dateTimeRange.start,
                status: _status,
              );
            }
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollState) {
              if (scrollState is ScrollEndNotification &&
                  _shipmentCubit.state is! ListPaginateLast) {
                _shipmentCubit.fetchShipmentReportsPaginate(
                  endDate: _dateTimeRange.end,
                  startDate: _dateTimeRange.start,
                  status: _status,
                );
              }

              return false;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                // App Bar
                SliverAppBar(
                  actions: <Widget>[
                    PopupMenuButton(
                      itemBuilder: (context) => <PopupMenuItem>[
                        PopupMenuItem(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                CreateReportDateRangeDialog(status: _status),
                          ),
                          child: const Text('Buat Laporan'),
                        ),
                      ],
                    ),
                  ],
                  backgroundColor: MaterialColors.surfaceContainerLowest,
                  expandedHeight: kToolbarHeight + kSpaceBarHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton.icon(
                              onPressed: () async {
                                final dateTimeRangePicked =
                                    await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                        locale: const Locale('id'));

                                if (dateTimeRangePicked == null) return;

                                _dateTimeRange = dateTimeRangePicked;
                                final startDate = dateTimeRangePicked.start;
                                final endDate = dateTimeRangePicked.end;
                                setState(() => _dateTimeRangePicked =
                                    '${startDate.toDMY} s.d.\n${endDate.toDMY}');

                                await _shipmentCubit.fetchShipmentReports(
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

                                  _status = value;
                                  _shipmentCubit.fetchShipmentReports(
                                    endDate: _dateTimeRange.end,
                                    startDate: _dateTimeRange.start,
                                    status: _status,
                                  );
                                },
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
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
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: MaterialColors.outlineVariant,
                      width: 1,
                    ),
                  ),
                  snap: true,
                  title: const Text('Laporan'),
                ),
                // List
                BlocBuilder<ShipmentCubit, ShipmentState>(
                  bloc: _shipmentCubit,
                  buildWhen: (previous, current) =>
                      current is FetchShipmentReports,
                  builder: (context, state) {
                    if (state is FetchShipmentReportsLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    if (state is FetchShipmentReportsLoaded) {
                      if (state.shipmentReports.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text('Belum ada laporan'),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList.builder(
                          itemBuilder: (context, index) =>
                              ShipmentReportListItem(
                            shipmentReport: state.shipmentReports[index],
                          ),
                          itemCount: state.shipmentReports.length,
                        ),
                      );
                    }

                    return const SizedBox();
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
      ),
    );
  }
}
