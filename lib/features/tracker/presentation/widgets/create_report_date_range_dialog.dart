import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/top_snackbar.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../cubit/shipment_report/shipment_report_cubit.dart';

class CreateReportDateRangeDialog extends StatefulWidget {
  const CreateReportDateRangeDialog({
    super.key,
    required this.status,
  });

  final String status;

  @override
  State<CreateReportDateRangeDialog> createState() => _DateRangeDialogState();
}

class _DateRangeDialogState extends State<CreateReportDateRangeDialog> {
  late final ShipmentReportCubit _shipmentCubit;
  late final TextEditingController _dateController;
  late final GlobalKey<FormState> _formKey;
  var _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    final startDate = _dateTimeRange.start;
    final endDate = _dateTimeRange.end;
    _shipmentCubit = context.read<ShipmentReportCubit>();
    _dateController =
        TextEditingController(text: '${startDate.toDMY} s.d. ${endDate.toDMY}');
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Buat Laporan',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan pilih rentang tanggal untuk membuat laporan',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              onTap: () async {
                final dateTimeRangePicked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    locale: const Locale('id'));

                if (dateTimeRangePicked == null) return;

                _dateTimeRange = dateTimeRangePicked;
                final startDate = dateTimeRangePicked.start;
                final endDate = dateTimeRangePicked.end;
                _dateController.text =
                    '${startDate.toDMY} s.d. ${endDate.toDMY}';
              },
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Rentang Tanggal',
              ),
              readOnly: true,
              textInputAction: TextInputAction.send,
              validator: inputValidator,
            ),
            const SizedBox(height: 24),
            BlocConsumer<ShipmentReportCubit, ShipmentReportState>(
              buildWhen: (previous, current) => current is CreateShipmentReport,
              listenWhen: (previous, current) =>
                  current is CreateShipmentReport,
              listener: (context, state) {
                if (state is CreateShipmentReportLoaded) {
                  TopSnackbar.successSnackbar(message: state.message);
                  context.pop();
                }

                if (state is CreateShipmentReportError) {
                  TopSnackbar.dangerSnackbar(message: state.message);
                }
              },
              builder: (context, state) {
                if (state is CreateShipmentReportLoading) {
                  return const PrimaryButton(
                    child: Text('Buat Laporan'),
                  );
                }

                return PrimaryButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    _shipmentCubit.createShipmentReport(
                      startDate: _dateTimeRange.start,
                      endDate: _dateTimeRange.end,
                    );
                  },
                  child: const Text('Buat Laporan'),
                );
              },
            ),
            TextButton(
              onPressed: context.pop,
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}
