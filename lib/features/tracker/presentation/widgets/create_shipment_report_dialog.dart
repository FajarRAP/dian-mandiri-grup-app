import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/confirmation_input_dialog.dart';
import '../cubit/shipment_report/shipment_report_cubit.dart';

class CreateReportDateRangeDialog extends StatefulWidget {
  const CreateReportDateRangeDialog({super.key, required this.status});

  final String status;

  @override
  State<CreateReportDateRangeDialog> createState() => _DateRangeDialogState();
}

class _DateRangeDialogState extends State<CreateReportDateRangeDialog> {
  late final ShipmentReportCubit _shipmentCubit;
  var _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _shipmentCubit = context.read<ShipmentReportCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShipmentReportCubit, ShipmentReportState>(
      listener: (context, state) {
        if (state.actionStatus == ShipmentReportActionStatus.failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        }

        if (state.actionStatus == ShipmentReportActionStatus.success) {
          TopSnackbar.successSnackbar(message: state.message!);
          context.pop();
        }
      },
      builder: (context, state) {
        final onConfirm = switch (state.actionStatus) {
          ShipmentReportActionStatus.inProgress => null,
          _ => (String value) => _shipmentCubit.createShipmentReport(
            startDate: _dateTimeRange.start,
            endDate: _dateTimeRange.end,
          ),
        };
        return ConfirmationInputDialog(
          onConfirm: onConfirm,
          fieldBuilder: (context, controller) => TextFormField(
            onTap: () async {
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
              controller.text = '${startDate.toDMY} s.d. ${endDate.toDMY}';
            },
            controller: controller,
            decoration: const InputDecoration(labelText: 'Rentang Tanggal'),
            readOnly: true,
            validator: inputValidator,
          ),
          actionText: 'Buat laporan',
          body: 'Silakan pilih rentang tanggal untuk membuat laporan',
          title: 'Buat Laporan',
        );
      },
    );
  }
}
