import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

extension StringNullableExtension on String? {
  Future<MultipartFile?> toMultipartFile() async {
    if (this == null || this!.trim().isEmpty) return null;

    if (this!.startsWith(RegExp(r'httpp|https'))) {
      return null;
    }

    return await MultipartFile.fromFile(this!);
  }
}

extension BuildContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension FileExtension on File {
  String get fileName => path.split('/').last;
}
