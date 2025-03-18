import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
    this.child = const SizedBox(),
  });

  final String title;
  final String body;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: .12),
          )
        ],
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium,
              ),
              Text(
                body,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }
}
