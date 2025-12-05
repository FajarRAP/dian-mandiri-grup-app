import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/themes/colors.dart';

class TopSnackbar {
  static late BuildContext _context;

  static void init(BuildContext context) => _context = context;

  static void dangerSnackbar({required String message}) =>
      _showSnackbar(message: message, color: MaterialColors.error);

  static void successSnackbar({required String message}) =>
      _showSnackbar(message: message, color: Colors.green);

  static void defaultSnackbar({required String message}) =>
      _showSnackbar(message: message, color: Colors.grey.shade900);

  static void _showSnackbar({required String message, required Color color}) {
    final overlay = Overlay.of(_context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 24,
        left: 16,
        right: 16,
        child: _buildSnackbar(color: color, text: message)
            .animate()
            .slideY(begin: -3, end: 0)
            .then()
            .slideY(begin: 0.15, end: 0, duration: 200.ms)
            .then()
            .slideY(begin: 0, end: 0.15, duration: 200.ms)
            .then(delay: 1.seconds)
            .slideY(begin: 0, end: -3),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(2.seconds, overlayEntry.remove);
  }

  static Widget _buildSnackbar({required Color color, required String text}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 6,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
