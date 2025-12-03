import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

extension DateTimeFormatter on DateTime {
  String get toYMD => DateFormat('y-MM-dd', 'id_ID').format(this);
  String get toDMY => DateFormat('dd-MM-y', 'id_ID').format(this);
  String get toDMYHMS => DateFormat('dd-MM-y HH:mm:ss', 'id_ID').format(this);
  String get toHMS => DateFormat('HH:mm:ss', 'id_ID').format(this);
}

extension NumberFormatter on num {
  String get toIDRCurrency => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(this);
}
