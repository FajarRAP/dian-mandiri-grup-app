import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push(route),
      child: Card(
        child: SizedBox(
          height: size,
          width: size,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.shade100,
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  assetName,
                  height: 72,
                  width: 72,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
