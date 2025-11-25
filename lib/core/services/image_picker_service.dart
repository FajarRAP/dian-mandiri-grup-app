import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum PickImageSource {
  camera,
  gallery,
}

abstract interface class ImagePickerService {
  Future<File?> pickImageFromGallery();
  Future<File?> pickImageFromCamera();
}

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<File?> pickImageFromGallery() async {
    final pickedImage = await _imagePicker.pickImage(
      imageQuality: 60,
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }

  @override
  Future<File?> pickImageFromCamera() async {
    final pickedImage = await _imagePicker.pickImage(
      imageQuality: 60,
      source: ImageSource.camera,
    );

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }
}
