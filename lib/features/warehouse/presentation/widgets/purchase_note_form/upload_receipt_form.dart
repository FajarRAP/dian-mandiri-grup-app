import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/buttons/primary_outline_button.dart';
import '../../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../../../../../core/widgets/preview_picked_image_dialog.dart';

class UploadReceiptForm extends StatelessWidget {
  const UploadReceiptForm({super.key, this.onPicked, this.image});

  final void Function(File file)? onPicked;
  final File? image;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: .start,
      spacing: 4,
      children: [
        Text('Unggah Gambar Nota', style: textTheme.bodyLarge),
        SizedBox(
          width: 150,
          child: PrimaryButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => ImagePickerBottomSheet(onPicked: onPicked),
            ),
            child: const Text('Ambil Gambar'),
          ),
        ),
        if (image != null)
          SizedBox(
            width: 150,
            child: PrimaryOutlineButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    PreviewPickedImageDialog(pickedImagePath: image?.path),
              ),
              child: const Text('Preview Gambar'),
            ),
          ),
      ],
    );
  }
}
