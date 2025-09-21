import 'package:flutter/material.dart';

import '../../../../core/common/shadows.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/stage_entity.dart';

class ReceiptStatusHistoryTimeline extends StatelessWidget {
  const ReceiptStatusHistoryTimeline({
    super.key,
    required this.isLast,
    required this.stage,
  });

  final bool isLast;
  final StageEntity stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final stageName = evaluateStage(stage.stage);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 5,
                    color: CustomColors.primaryNormal.withValues(alpha: .3),
                  )
                ],
                color: CustomColors.primaryNormal.withValues(alpha: .6),
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: const Icon(
                Icons.circle,
                color: Colors.white,
                size: 12,
              ),
            ),
            if (!isLast)
              Container(
                color: CustomColors.primaryNormal.withValues(alpha: .3),
                height: 60,
                width: 2,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: cardBoxShadow,
                  color: MaterialColors.surfaceContainerLowest,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stageName,
                      style: textTheme.titleMedium?.copyWith(
                        color: CustomColors.primaryNormal.withValues(alpha: .8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.grey.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          stage.user.name,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          stage.date.toLocal().toDMYHMS,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
