import 'dart:io';

import '../../../service_container.dart';
import '../../services/image_picker_service.dart';

mixin ImagePickerMixin {
  Future<void> pickFromGallery({void Function(File image)? onPicked}) async {
    final image = await getIt<ImagePickerService>().pickImageFromGallery();

    if (image == null) return;

    onPicked?.call(image);
  }

  Future<void> pickFromCamera({void Function(File image)? onPicked}) async {
    final image = await getIt<ImagePickerService>().pickImageFromCamera();

    if (image == null) return;

    onPicked?.call(image);
  }
}
