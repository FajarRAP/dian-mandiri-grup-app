import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/mixins/image_picker_mixin.dart';
import '../utils/extensions.dart';

class ImagePickerBottomSheet extends StatelessWidget with ImagePickerMixin {
  const ImagePickerBottomSheet({
    super.key,
    this.onCameraPick,
    this.onGalleryPick,
    this.onPicked,
  });

  final void Function(File image)? onCameraPick;
  final void Function(File image)? onGalleryPick;
  final void Function(File image)? onPicked;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          onTap: () async {
            context.pop();
            onCameraPick != null
                ? await pickFromCamera(onPicked: onCameraPick)
                : await pickFromCamera(onPicked: onPicked);
          },
          leading: Icon(Icons.camera_alt, color: context.colorScheme.primary),
          title: const Text('Ambil dari Kamera'),
        ),
        ListTile(
          onTap: () async {
            context.pop();
            onGalleryPick != null
                ? await pickFromGallery(onPicked: onGalleryPick)
                : await pickFromGallery(onPicked: onPicked);
          },
          leading: Icon(
            Icons.photo_library,
            color: context.colorScheme.primary,
          ),
          title: const Text('Pilih dari Galeri'),
        ),
      ],
    );
  }
}
