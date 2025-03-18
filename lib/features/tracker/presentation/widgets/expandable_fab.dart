import 'dart:math';

import 'package:flutter/material.dart';

class ExpandableFAB extends StatefulWidget {
  const ExpandableFAB({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  var _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: _open ? 1.0 : 0.0,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
      reverseCurve: Curves.easeOutQuad,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      _open ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildCloseFab(),
          ..._buildExpandingIconButtons(),
          _buildOpenFab(),
        ],
      ),
    );
  }

  Widget _buildCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingIconButtons() {
    final children = <Widget>[];
    final length = widget.children.length;
    final step = 90.0 / (length - 1);

    for (var i = 0, angleInDegrees = 0.0;
        i < length;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingIconButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }

    return children;
  }

  Widget _buildOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        curve: const Interval(0, .5, curve: Curves.easeOut),
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.diagonal3Values(
          _open ? .7 : 1,
          _open ? .7 : 1,
          1,
        ),
        transformAlignment: Alignment.center,
        child: AnimatedOpacity(
          curve: const Interval(.25, 1, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 300),
          opacity: _open ? 0 : 1,
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingIconButton extends StatelessWidget {
  const _ExpandingIconButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (pi / 180),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
