import 'package:flutter/material.dart';

SnackBar successSnackbar(String message, [EdgeInsetsGeometry? margin]) =>
    SnackBar(
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
      margin: margin,
    );

SnackBar dangerSnackbar(String message, [EdgeInsetsGeometry? margin]) =>
    SnackBar(
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
      margin: margin,
    );
