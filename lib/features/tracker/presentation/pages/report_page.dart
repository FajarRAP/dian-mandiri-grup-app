import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../cubit/ship_cubit.dart';

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
    final shipCubit = context.read<ShipCubit>();

    return BlocListener<ShipCubit, ShipState>(
      listener: (context, state) {
        if (state is CreateReport) {
          flushbar(context, state.message);
          shipCubit.getAllSpreadsheetFiles();
        }
        if (state is ReportError) {
          flushbar(context, state.message);
        }
      },
      child: Scaffold(
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
        body: BlocBuilder<ShipCubit, ShipState>(
          bloc: shipCubit..getAllSpreadsheetFiles(),
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AllReport) {
              return RefreshIndicator(
                displacement: 10,
                onRefresh: shipCubit.getAllSpreadsheetFiles,
                child: ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.only(left: 16),
                    leading: Image.asset(spreadsheetIcon),
                    title: Text(shipCubit
                        .shortFilename[state.reports.length - index - 1]),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => <PopupMenuItem>[
                        PopupMenuItem(
                          onTap: () => OpenFilex.open(
                              state.reports[state.reports.length - index - 1]),
                          child: const Text('Buka'),
                        ),
                        PopupMenuItem(
                          onTap: () async => await Share.shareXFiles([
                            XFile(
                                state.reports[state.reports.length - index - 1])
                          ]),
                          child: const Text('Bagikan'),
                        ),
                      ],
                    ),
                  ),
                  itemCount: state.reports.length,
                ),
              );
            }
            return const SizedBox();
          },
        ),
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
      setState(() => _dateController.text =
          DateFormat('d-M-y', 'id_ID').format(datePicked));
      date = datePicked;
    }
  }

  void _showDialogToCreateReport() async {
    final shipCubit = context.read<ShipCubit>();
    date = DateUtils.dateOnly(DateTime.now());
    _dateController.text = DateFormat('d-M-y', 'id_ID').format(DateTime.now());
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tanggal'),
        content: StatefulBuilder(
          builder: (context, setState) => TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_month_outlined),
            ),
            readOnly: true,
            onTap: _showDatePicker,
          ),
        ),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await shipCubit.createReport(date);
              if (!context.mounted) return;
              context.pop();
            },
            child: BlocBuilder<ShipCubit, ShipState>(
              builder: (context, state) {
                if (state is ReportLoading) {
                  return const CircularProgressIndicator();
                }
                return const Text('Buat');
              },
            ),
          ),
        ],
      ),
    );
  }
}
