import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../themes/colors.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    super.key,
    this.onCameraPick,
    this.onGalleryPick,
    this.onPicked,
  });

  final void Function()? onCameraPick;
  final void Function()? onGalleryPick;
  final void Function(XFile image)? onPicked;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          onTap: () {
            context.pop();
            onCameraPick?.call();
          },
          leading: const Icon(
            Icons.camera_alt,
            color: CustomColors.primaryNormal,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          title: const Text('Ambil dari Kamera'),
        ),
        ListTile(
          onTap: () {
            context.pop();
            onGalleryPick?.call();
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
