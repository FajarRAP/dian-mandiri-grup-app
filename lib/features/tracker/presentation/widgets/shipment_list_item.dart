import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
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
    final uriPath = GoRouterState.of(context).uri.path;
    final theme = Theme.of(context);
    final authCubit = context.read<AuthCubit>();
    final textTheme = theme.textTheme;
    final permissions = authCubit.user.permissions;
    final isSuperAdmin = permissions.contains(superAdminPermission);

    return Card(
      color: MaterialColors.surfaceContainerLowest,
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: Row(
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: MaterialColors.primaryContainer,
              child: Icon(
                Icons.local_shipping,
                color: CustomColors.primaryNormal,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    shipment.receiptNumber,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shipment.date.toLocal().toHMS,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kurir: ${shipment.courier}',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSuperAdmin)
              PopupMenuButton(
                padding: EdgeInsets.zero,
                itemBuilder: (context) => <PopupMenuEntry>[
                  if (uriPath != cancelReceiptRoute)
                    PopupMenuItem(
                      onTap: onCancel,
                      child: const Text('Cancel'),
                    ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: const Text('Hapus'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
