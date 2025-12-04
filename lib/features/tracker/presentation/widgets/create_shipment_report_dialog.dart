import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/top_snackbar.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/presentation/widgets/confirmation_input_dialog.dart';
import '../cubit/create_shipment_report/create_shipment_report_cubit.dart';

class CreateShipmentReportDialog extends StatelessWidget {
  const CreateShipmentReportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateShipmentReportCubit, CreateShipmentReportState>(
      listener: (context, state) {
        if (state.status == .success) {
          TopSnackbar.successSnackbar(message: state.message!);
          context.pop(true);
        }

        if (state.status == .failure) {
          TopSnackbar.dangerSnackbar(message: state.failure!.message);
        }
      },
      builder: (context, state) {
        final onConfirm = switch (state.status) {
          .inProgress => null,
          _ =>
            (String value) => context
                .read<CreateShipmentReportCubit>()
                .createShipmentReport(),
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

              if (dateTimeRangePicked == null || !context.mounted) return;

              context.read<CreateShipmentReportCubit>().dateTimeRange =
                  dateTimeRangePicked;
              controller.text =
                  '${dateTimeRangePicked.start.toDMY} s.d. ${dateTimeRangePicked.end.toDMY}';
            },
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            controller: controller,
            decoration: const InputDecoration(labelText: 'Rentang Tanggal'),
            readOnly: true,
            validator: Validator.inputValidator,
          ),
          actionText: 'Buat laporan',
          body: 'Silakan pilih rentang tanggal untuk membuat laporan',
          title: 'Buat Laporan',
        );
      },
    );
  }
}
