import 'package:flutter/material.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final focusNode = FocusScope.of(context, createDependency: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        TextFormField(
          onTapOutside: (event) => focusNode.unfocus(),
          initialValue: value,
          maxLines: maxLines,
          readOnly: true,
        ),
      ],
    );
  }
}
