import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/helpers.dart';
import '../cubit/shipment_cubit.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  var _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  var _status = completedReport;
  var _dateTimeRangePicked = 'Pilih Range Tanggal';

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuItem>[
              PopupMenuItem(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => DateRangePickerDialog(status: _status),
                ),
                child: const Text('Buat Laporan'),
              ),
            ],
          ),
        ],
        title: const Text('Laporan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _showDateRangePicker,
                  label: Text(_dateTimeRangePicked),
                  icon: const Icon(Icons.calendar_month_rounded),
                ),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    onChanged: (value) {
                      if (value == null) return;
                      _status = value;
                      shipmentCubit.fetchShipmentReports(
                          endDate: dateFormat.format(_dateTimeRange.end),
                          startDate: dateFormat.format(_dateTimeRange.start),
                          status: _status);
                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: pendingReport,
                        child: const Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: processingReport,
                        child: const Text('Processing'),
                      ),
                      DropdownMenuItem(
                        value: completedReport,
                        child: const Text('Compeleted'),
                      ),
                      DropdownMenuItem(
                        value: failedReport,
                        child: const Text('Failed'),
                      ),
                    ],
                    value: _status,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocConsumer<ShipmentCubit, ShipmentState>(
              bloc: shipmentCubit
                ..getExternalPath()
                ..fetchShipmentReports(
                    endDate: dateFormat.format(_dateTimeRange.end),
                    startDate: dateFormat.format(_dateTimeRange.start),
                    status: _status),
              buildWhen: (previous, current) => current is FetchShipmentReports,
              listenWhen: (previous, current) =>
                  current is DownloadShipmentReport,
              listener: (context, state) {
                if (state is DownloadShipmentReportLoaded) {
                  flushbar(state.message);
                }

                if (state is DownloadShipmentReportError) {
                  flushbar(state.message);
                }
              },
              builder: (context, state) {
                if (state is FetchShipmentReportsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FetchShipmentReportsLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async => shipmentCubit.fetchShipmentReports(
                        endDate: dateFormat.format(_dateTimeRange.end),
                        startDate: dateFormat.format(_dateTimeRange.start),
                        status: _status),
                    displacement: 10,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final shipmentReport = state.shipmentReports[index];
                        final filename = shipmentReport.name;
                        final date = shipmentReport.date;
                        final formattedDate = timeFormat.format(date.toLocal());
                        final savedFilename = '${filename}_$formattedDate';
                        final file = File(
                            '${shipmentCubit.externalPath}/$savedFilename.xlsx');
                        return ListTile(
                          contentPadding: const EdgeInsets.only(left: 16),
                          leading: Image.asset(spreadsheetIcon),
                          title: Text(savedFilename),
                          trailing: PopupMenuButton<String>(
                            itemBuilder: (context) => <PopupMenuItem<String>>[
                              PopupMenuItem(
                                onTap: () async =>
                                    await shipmentCubit.downloadShipmentReport(
                                  shipmentReportEntity: shipmentReport,
                                ),
                                child: const Text('Unduh'),
                              ),
                              if (file.existsSync()) ...[
                                PopupMenuItem(
                                  onTap: () async {
                                    final directory =
                                        await getExternalStorageDirectory();
                                    final file = File(
                                        '${directory?.path}/$savedFilename.xlsx');
                                    await OpenFilex.open(file.path);
                                  },
                                  child: const Text('Buka'),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    final directory =
                                        await getExternalStorageDirectory();
                                    final files = [
                                      XFile(
                                          '${directory?.path}/$savedFilename.xlsx'),
                                    ];
                                    await Share.shareXFiles(files);
                                  },
                                  child: const Text('Bagikan'),
                                ),
                              ]
                            ],
                          ),
                        );
                      },
                      itemCount: state.shipmentReports.length,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker() async {
    final dateTimeRangePicked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: const Locale('id'));

    if (dateTimeRangePicked == null) return;
    _dateTimeRange = dateTimeRangePicked;
    final startDate = dMyFormat.format(dateTimeRangePicked.start);
    final endDate = dMyFormat.format(dateTimeRangePicked.end);
    setState(() => _dateTimeRangePicked = '$startDate s.d.\n $endDate');
  }
}

class DateRangePickerDialog extends StatefulWidget {
  const DateRangePickerDialog({
    super.key,
    required this.status,
  });

  final String status;

  @override
  State<DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> {
  final _dateController = TextEditingController();
  var _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    final startDate = dMyFormat.format(_dateTimeRange.start);
    final endDate = dMyFormat.format(_dateTimeRange.end);
    _dateController.text = '$startDate - $endDate';
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();

    return AlertDialog(
      actions: [
        TextButton(onPressed: context.pop, child: const Text('Batal')),
        TextButton(
          onPressed: () async => await shipmentCubit.createShipmentReport(
            endDate: dateFormat.format(_dateTimeRange.end),
            startDate: dateFormat.format(_dateTimeRange.start),
          ),
          child: BlocConsumer<ShipmentCubit, ShipmentState>(
            buildWhen: (previous, current) => current is CreateShipmentReport,
            listenWhen: (previous, current) => current is CreateShipmentReport,
            listener: (context, state) {
              if (state is CreateShipmentReportLoaded) {
                context.pop();
                flushbar(state.message);
                shipmentCubit.fetchShipmentReports(
                    endDate: dateFormat.format(_dateTimeRange.end),
                    startDate: dateFormat.format(_dateTimeRange.start),
                    status: widget.status);
              }

              if (state is CreateShipmentReportError) {
                flushbar(state.message);
              }
            },
            builder: (context, state) {
              if (state is CreateShipmentReportLoading) {
                return const CircularProgressIndicator();
              }

              return const Text('Buat');
            },
          ),
        ),
      ],
      content: TextFormField(
        onTap: _showDateRangePicker,
        controller: _dateController,
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.calendar_month_outlined),
        ),
        readOnly: true,
      ),
      title: const Text('Pilih Range Tanggal'),
    );
  }

  void _showDateRangePicker() async {
    final dateTimeRangePicked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: const Locale('id'));

    if (dateTimeRangePicked == null) return;
    _dateTimeRange = dateTimeRangePicked;
    final startDate = dMyFormat.format(dateTimeRangePicked.start);
    final endDate = dMyFormat.format(dateTimeRangePicked.end);
    setState(() => _dateController.text = '$startDate - $endDate');
  }
}
