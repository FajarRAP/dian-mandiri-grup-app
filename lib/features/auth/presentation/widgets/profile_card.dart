import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/utils/extensions.dart';

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
    final textTheme = context.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: .circular(4),
        boxShadow: cardBoxShadow,
        color: context.colorScheme.surfaceContainerLowest,
      ),
      padding: const .all(10),
      width: .infinity,
      child: Row(
        children: <Widget>[
          Icon(icon, color: context.colorScheme.primary),
          const Gap(18),
          Column(
            crossAxisAlignment: .start,
            children: <Widget>[
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(fontWeight: .w500),
              ),
              Text(body, style: textTheme.bodyMedium),
            ],
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }
}
