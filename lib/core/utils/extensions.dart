import 'package:dio/dio.dart';

extension StringNullableExtension on String? {
  Future<MultipartFile?> toMultipartFile() async {
    if (this == null || this!.trim().isEmpty) return null;

    if (this!.startsWith(RegExp(r'httpp|https'))) {
      return null;
    }

    return await MultipartFile.fromFile(this!);
  }
}
