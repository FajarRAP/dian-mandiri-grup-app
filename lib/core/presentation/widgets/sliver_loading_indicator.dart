import 'package:flutter/widgets.dart';

import 'loading_indicator.dart';

class SliverLoadingIndicator extends StatelessWidget {
  const SliverLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: LoadingIndicator(),
    );
  }
}
