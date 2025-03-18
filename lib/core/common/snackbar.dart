import 'package:flutter/material.dart';

SnackBar successSnackbar(String message) => SnackBar(
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    );

SnackBar dangerSnackbar(String message) => SnackBar(
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    );
