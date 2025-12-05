import 'package:flutter/material.dart';

import '../../errors/failure.dart';
import 'error_state_widget.dart';

class SliverErrorStateWidget extends StatelessWidget {
  const SliverErrorStateWidget({
    super.key,
    this.onRetry,
    this.failure,
    this.message,
    this.compact = false,
  });

  final void Function()? onRetry;
  final Failure? failure;
  final String? message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ErrorStateWidget(
        onRetry: onRetry,
        failure: failure,
        message: message,
        compact: compact,
      ),
    );
  }
}
