import 'package:flutter/material.dart';

import '../utils/extensions.dart';

class ReadOnlyField extends StatelessWidget {
  const ReadOnlyField({
    super.key,
    this.maxLines = 1,
    required this.title,
    required this.value,
  });

  final int maxLines;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: <Widget>[
        Text(title, style: textTheme.bodyLarge),
        TextFormField(initialValue: value, maxLines: maxLines, readOnly: true),
      ],
    );
  }
}
