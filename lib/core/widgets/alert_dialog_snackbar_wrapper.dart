import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertDialogSnackbarWrapper extends StatelessWidget {
  const AlertDialogSnackbarWrapper({
    super.key,
    required this.dialog,
  });

  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: context.pop,
            behavior: HitTestBehavior.opaque,
            child: GestureDetector(
              onTap: () {},
              child: dialog,
            ),
          ),
        ),
      ),
    );
  }
}
