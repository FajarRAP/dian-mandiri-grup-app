import 'package:flutter/material.dart';

import '../../../../../core/utils/extensions.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({super.key, this.onChanged});

  final void Function(String value)? onChanged;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [
        Text('Catatan', style: textTheme.bodyLarge),
        TextFormField(
          onChanged: widget.onChanged,
          controller: _noteController,
          decoration: const InputDecoration(
            hintText: 'Tuliskan catatan jika ada',
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
