import 'package:flutter/widgets.dart';

import '../../utils/extensions.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Belum ada data', style: context.textTheme.bodyMedium),
    );
  }
}
