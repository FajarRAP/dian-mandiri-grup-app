import 'package:flutter/material.dart';

import '../../../../../core/helpers/helpers.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/utils/extensions.dart';

class SelectDateForm extends StatefulWidget {
  const SelectDateForm({super.key, required this.onTap, this.pickedDate});

  final void Function(DateTime? date) onTap;
  final DateTime? pickedDate;

  @override
  State<SelectDateForm> createState() => _SelectDateFormState();
}

class _SelectDateFormState extends State<SelectDateForm> {
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SelectDateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pickedDate != oldWidget.pickedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final newText = widget.pickedDate?.toDMY ?? '';
        if (_dateController.text != newText) {
          _dateController.text = newText;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [
        Text('Tanggal', style: textTheme.bodyLarge),
        TextFormField(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              initialDate: DateTime.now(),
              lastDate: DateTime.now(),
              locale: const Locale('id', 'ID'),
            );

            widget.onTap(pickedDate);
          },
          autovalidateMode: .onUserInteraction,
          controller: _dateController,
          decoration: const InputDecoration(
            hintText: 'Tanggal',
            suffixIcon: Icon(Icons.date_range),
          ),
          readOnly: true,
          validator: nullValidator,
        ),
      ],
    );
  }
}
