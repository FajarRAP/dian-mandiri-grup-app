import 'package:flutter/material.dart';

class ItemNotFound extends StatelessWidget {
  const ItemNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Image
        // const SizedBox(height: 12),
        Text(
          'Pencarian tidak ditemukan',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
