import 'package:flutter/material.dart';

import '../../../../core/helpers/helpers.dart';
import '../../data/models/stage_model.dart';
import '../../domain/entities/stage_entity.dart';

class ReceiptHistoryRow extends StatelessWidget {
  const ReceiptHistoryRow({
    super.key,
    required this.isLast,
    required this.stage,
  });

  final bool isLast;
  final StageEntity stage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final stageName = evaluateStage(stage.stage);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.green.withValues(alpha: 0.3),
                  )
                ],
                color: Colors.green.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: Icon(
                Icons.circle,
                color: Colors.white,
                size: 12,
              ),
            ),
            if (!isLast)
              Container(
                color: Colors.green.withValues(alpha: 0.3),
                height: 60,
                width: 2,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stageName,
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.green.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.grey.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (stage as StageModel).user.name,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateTimeFormat.format(stage.date.toLocal()),
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
