import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/extensions.dart';

class TrackerMenuCard extends StatelessWidget {
  const TrackerMenuCard({
    super.key,
    required this.title,
    required this.route,
    required this.color,
    required this.assetName,
    this.size,
  });

  final String title;
  final String route;
  final MaterialColor color;
  final String assetName;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return GestureDetector(
      onTap: () => context.pushNamed(route),
      child: Card(
        child: SizedBox(
          height: size,
          width: size,
          child: Column(
            mainAxisAlignment: .center,
            mainAxisSize: .min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(8),
                  color: color.shade100,
                ),
                padding: const .all(6),
                child: Image.asset(assetName, height: 72, width: 72),
              ),
              const Gap(14),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(fontWeight: .w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
