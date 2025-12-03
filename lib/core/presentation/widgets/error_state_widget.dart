import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../errors/failure.dart';
import '../../utils/extensions.dart';
import 'buttons/danger_button.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    this.failure,
    this.message,
    this.onRetry,
    this.compact = false,
  });

  final Failure? failure;
  final String? message;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final displayMessage = message ?? failure?.message ?? 'Terjadi kesalahan';

    return Center(
      child: Padding(
        padding: const .all(24.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            _buildIcon(context),
            Gap(compact ? 8 : 16),
            Text(
              displayMessage,
              textAlign: .center,
              style: compact
                  ? context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    )
                  : context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
            ),
            if (onRetry != null) ...[
              Gap(compact ? 12 : 24),

              SizedBox(
                height: compact ? 36 : 48,
                child: DangerButton(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh_rounded, size: compact ? 18 : 24),
                  child: Text(
                    'Coba Lagi',
                    style: TextStyle(fontSize: compact ? 12 : 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final IconData icon;

    if (failure != null) {
      icon = switch (failure) {
        NetworkFailure() => Icons.wifi_off_rounded,
        ServerFailure() => Icons.dns_rounded,
        CacheFailure() => Icons.save_outlined,
        _ => Icons.error_outline_rounded,
      };
    } else {
      icon = Icons.error_outline_rounded;
    }

    return Icon(
      icon,
      size: compact ? 48 : 100,
      color: context.colorScheme.error,
    );
  }
}
