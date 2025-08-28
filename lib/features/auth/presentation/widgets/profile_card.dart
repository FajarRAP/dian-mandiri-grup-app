import 'package:flutter/material.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/themes/colors.dart';

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
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: cardBoxShadow,
        color: MaterialColors.surfaceContainerLowest,
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: CustomColors.primaryNormal,
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
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
