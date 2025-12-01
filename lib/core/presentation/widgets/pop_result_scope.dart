import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PopResultScope<T> extends StatelessWidget {
  const PopResultScope({
    super.key,
    this.onPopInvoked,
    required this.child,
    required this.value,
  });

  final void Function(bool didPop)? onPopInvoked;
  final T value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        onPopInvoked?.call(didPop);

        context.pop(value);
      },
      canPop: false,
      child: child,
    );
  }
}
