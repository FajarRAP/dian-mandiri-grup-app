import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../common/constants/app_permissions.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/presentation/cubit/user_cubit.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/shipment_entity.dart';

class ShipmentListItem extends StatelessWidget {
  const ShipmentListItem({
    super.key,
    this.onCancel,
    this.onDelete,
    required this.shipment,
  });

  final void Function()? onCancel;
  final void Function()? onDelete;
  final ShipmentEntity shipment;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final isSuperAdmin = context.read<UserCubit>().can(
      AppPermissions.superAdmin,
    );

    return Card(
      color: context.colorScheme.surfaceContainerLowest,
      elevation: 2,
      child: Container(
        padding: const .symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: context.colorScheme.primaryFixed,
              child: Icon(
                Icons.local_shipping,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  Text(shipment.receiptNumber, style: textTheme.titleMedium),
                  const Gap(4),
                  Text(
                    shipment.date.toLocal().toHMS,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Kurir: ${shipment.courier}',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: .w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSuperAdmin)
              PopupMenuButton(
                padding: EdgeInsets.zero,
                itemBuilder: (context) => <PopupMenuEntry>[
                  // if (uriPath != cancelReceiptRoute)
                  PopupMenuItem(onTap: onCancel, child: const Text('Cancel')),
                  PopupMenuItem(onTap: onDelete, child: const Text('Hapus')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
