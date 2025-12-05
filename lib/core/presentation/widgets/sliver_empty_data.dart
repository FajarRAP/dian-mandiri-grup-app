import 'package:flutter/widgets.dart';

import 'empty_data.dart';

class SliverEmptyData extends StatelessWidget {
  const SliverEmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(hasScrollBody: false, child: EmptyData());
  }
}
