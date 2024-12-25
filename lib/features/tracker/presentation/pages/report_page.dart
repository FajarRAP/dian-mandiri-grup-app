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
  final _dateController = TextEditingController();
  var date = DateTime.now();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuItem>[
              PopupMenuItem(
                onTap: _showDialogToCreateReport,
                child: const Text('Buat Laporan'),
              ),
            ],
          ),
        ],
        title: const Text('Laporan'),
      ),
      body: BlocConsumer<ShipmentCubit, ShipmentState>(
        bloc: shipmentCubit
          ..fetchShipmentReports(
              endDate: dateFormat.format(date),
              startDate: dateFormat.format(date),
              status: completedReport),
        buildWhen: (previous, current) => current is FetchShipmentReports,
        listenWhen: (previous, current) => current is DownloadShipmentReport,
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
                  endDate: dateFormat.format(date),
                  startDate: dateFormat.format(date),
                  status: completedReport),
              displacement: 10,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final filename = state.shipmentReports[index].name;
                  final date = state.shipmentReports[index].date;
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 16),
                    leading: Image.asset(spreadsheetIcon),
                    title: Text('${filename}_${dateTimeFormat.format(date)}'),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) => <PopupMenuItem<String>>[
                        PopupMenuItem(
                          onTap: () async {
                            final shipmentReport = state.shipmentReports[index];
                            await shipmentCubit.downloadShipmentReport(
                                shipmentReportEntity: shipmentReport);
                          },
                          child: const Text('Unduh'),
                        ),
                        PopupMenuItem(
                          onTap: () async {
                            final directory =
                                await getExternalStorageDirectory();
                            final file =
                                File('${directory?.path}/$filename.xlsx');
                            await OpenFilex.open(file.path);
                          },
                          child: const Text('Buka'),
                        ),
                        PopupMenuItem(
                          onTap: () async {
                            final directory =
                                await getExternalStorageDirectory();
                            final files = [
                              XFile('${directory?.path}/$filename.xlsx'),
                            ];
                            await Share.shareXFiles(files);
                          },
                          child: const Text('Bagikan'),
                        ),
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
    );
  }

  void _showDialogToCreateReport() async {
    final shipmentCubit = context.read<ShipmentCubit>();
    _dateController.text = dMyFormat.format(DateTime.now());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(onPressed: context.pop, child: const Text('Batal')),
          TextButton(
            onPressed: () async => await shipmentCubit.createShipmentReport(
              startDate: dateFormat.format(date),
              endDate: dateFormat.format(date),
            ),
            child: BlocConsumer<ShipmentCubit, ShipmentState>(
              buildWhen: (previous, current) => current is CreateShipmentReport,
              listenWhen: (previous, current) =>
                  current is CreateShipmentReport,
              listener: (context, state) {
                if (state is CreateShipmentReportLoaded) {
                  context.pop();
                  flushbar(state.message);
                  shipmentCubit.fetchShipmentReports(
                      startDate: dateFormat.format(date),
                      endDate: dateFormat.format(date),
                      status: completedReport);
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
          onTap: _showDatePicker,
          controller: _dateController,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_month_outlined),
          ),
          readOnly: true,
        ),
        title: const Text('Pilih Tanggal'),
      ),
    );
  }

  void _showDatePicker() async {
    final datePicked = await showDatePicker(
        context: context,
        confirmText: 'Oke',
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        locale: const Locale('id'));

    if (datePicked != null) {
      date = datePicked;
      setState(() => _dateController.text = dMyFormat.format(datePicked));
    }
  }
}
