import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPickedImageDialog extends StatelessWidget {
  const PreviewPickedImageDialog({
    super.key,
    required this.pickedImagePath,
  });

  final String? pickedImagePath;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      alignment: Alignment.center,
      contentPadding: const EdgeInsets.all(2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: pickedImagePath == null
            ? Text(
                'Belum memilih gambar',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
            : Image.file(
                File(pickedImagePath!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
