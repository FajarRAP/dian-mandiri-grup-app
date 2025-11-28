import 'package:flutter/material.dart';

class PaginationListener extends StatelessWidget {
  const PaginationListener({
    super.key,
    required this.onPaginate,
    this.threshold = 200.0,
    required this.child,
  });

  final void Function() onPaginate;
  final double threshold;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;

          if (metrics.pixels >= metrics.maxScrollExtent - threshold) {
            onPaginate();
          }
        }

        return false;
      },
      child: child,
    );
  }
}
