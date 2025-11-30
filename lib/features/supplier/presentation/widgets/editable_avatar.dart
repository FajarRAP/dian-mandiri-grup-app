import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class EditableAvatar extends StatelessWidget {
  const EditableAvatar({super.key, this.onTap, this.imageFile});

  final void Function()? onTap;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: UnconstrainedBox(
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              foregroundImage: imageFile == null ? null : FileImage(imageFile!),
              child: imageFile == null
                  ? Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade400,
                      size: 50,
                    )
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: .circle,
                ),
                padding: const .all(4),
                child: Icon(Icons.edit, color: context.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
