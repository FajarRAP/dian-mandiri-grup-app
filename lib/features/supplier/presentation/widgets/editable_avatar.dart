import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class EditableAvatar extends StatelessWidget {
  const EditableAvatar({super.key, this.onTap, this.imagePath});

  final void Function()? onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = imagePath != null && imagePath!.isNotEmpty;
    final onlineAvatar = imagePath?.startsWith('http') ?? false;
    final ImageProvider? avatar = hasAvatar
        ? (onlineAvatar
              ? NetworkImage(imagePath!)
              : FileImage(File(imagePath!)))
        : null;

    return GestureDetector(
      onTap: onTap,
      child: UnconstrainedBox(
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              foregroundImage: avatar,
              child: !hasAvatar
                  ? Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade400,
                      size: 50,
                    )
                  : null,
            ),
            if (onTap != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.colorScheme.surface,
                      width: 2,
                    ),
                    color: context.colorScheme.primary,
                    shape: .circle,
                  ),
                  padding: const .all(4),
                  child: Icon(
                    Icons.edit,
                    color: context.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
