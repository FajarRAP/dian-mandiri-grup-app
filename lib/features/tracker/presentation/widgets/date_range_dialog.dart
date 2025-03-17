import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/common/snackbar.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/widgets/alert_dialog_snackbar_wrapper.dart';
import '../cubit/shipment_cubit.dart';

class DateRangeDialog extends StatefulWidget {
  const DateRangeDialog({
    super.key,
    required this.status,
  });

  final String status;

  @override
  State<DateRangeDialog> createState() => _DateRangeDialogState();
}

class _DateRangeDialogState extends State<DateRangeDialog> {
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

    return AlertDialogSnackbarWrapper(
      dialog: AlertDialog(
        actions: [
          TextButton(
            onPressed: context.pop,
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async => await shipmentCubit.createShipmentReport(
              endDate: dateFormat.format(_dateTimeRange.end),
              startDate: dateFormat.format(_dateTimeRange.start),
            ),
            child: BlocConsumer<ShipmentCubit, ShipmentState>(
              buildWhen: (previous, current) => current is CreateShipmentReport,
              listenWhen: (previous, current) =>
                  current is CreateShipmentReport,
              listener: (context, state) {
                if (state is CreateShipmentReportLoaded) {
                  scaffoldMessengerKey.currentState
                      ?.showSnackBar(successSnackbar(state.message));
                  context.pop();
                  shipmentCubit.fetchShipmentReports(
                      endDate: dateFormat.format(_dateTimeRange.end),
                      startDate: dateFormat.format(_dateTimeRange.start),
                      status: widget.status);
                }

                if (state is CreateShipmentReportError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(dangerSnackbar(state.message));
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
          onTap: () async {
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
          },
          controller: _dateController,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_month_outlined),
          ),
          readOnly: true,
        ),
        title: const Text('Pilih Range Tanggal'),
      ),
    );
  }
}
