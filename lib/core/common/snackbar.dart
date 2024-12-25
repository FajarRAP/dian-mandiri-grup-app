import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
  BuildContext context,
  String message,
) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
      ),
    );

void flushbar(String message) {
  return FlashyFlushbar(
    animationDuration: const Duration(milliseconds: 400),
    duration: const Duration(milliseconds: 1600),
    message: message,
  ).show();
}
