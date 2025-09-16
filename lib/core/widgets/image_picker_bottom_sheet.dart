import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../themes/colors.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    super.key,
    required this.onPicked,
  });

  final void Function(XFile image) onPicked;

  @override
  Widget build(BuildContext context) {
    final imagePicker = ImagePicker();

    return Wrap(
      children: <Widget>[
        ListTile(
          onTap: () async {
            final pickedImage = await imagePicker.pickImage(
              imageQuality: 60,
              source: ImageSource.camera,
            );

            if (pickedImage == null) return;
            if (!context.mounted) return;
            context.pop();
            onPicked(pickedImage);
          },
          leading: const Icon(
            Icons.camera_alt,
            color: CustomColors.primaryNormal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          title: const Text('Ambil dari Kamera'),
        ),
        ListTile(
          onTap: () async {
            final pickedImage = await imagePicker.pickImage(
              imageQuality: 60,
              source: ImageSource.gallery,
            );

            if (pickedImage == null) return;
            if (!context.mounted) return;
            context.pop();
            onPicked(pickedImage);
          },
          leading: const Icon(
            Icons.photo_library,
            color: CustomColors.primaryNormal,
          ),
          title: const Text('Pilih dari Galeri'),
        ),
      ],
    );
  }
}
