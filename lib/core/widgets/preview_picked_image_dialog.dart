import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/extensions.dart';

class PreviewPickedImageDialog extends StatelessWidget {
  const PreviewPickedImageDialog({super.key, required this.pickedImagePath});

  final String? pickedImagePath;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return AlertDialog(
      alignment: .center,
      contentPadding: const .all(2),
      shape: RoundedRectangleBorder(borderRadius: .circular(6)),
      content: ClipRRect(
        borderRadius: .circular(6),
        child: pickedImagePath == null
            ? Text(
                'Belum memilih gambar',
                style: textTheme.bodyLarge?.copyWith(fontWeight: .w600),
                textAlign: .center,
              )
            : Image.file(File(pickedImagePath!), fit: .cover),
      ),
    );
  }
}
