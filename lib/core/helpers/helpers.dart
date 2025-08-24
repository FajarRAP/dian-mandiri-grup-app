import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../exceptions/refresh_token.dart';
import '../themes/colors.dart';

final dateFormat = DateFormat('y-MM-dd', 'id_ID');
final dateTimeFormat = DateFormat('dd-MM-y HH:mm:ss', 'id_ID');
final dMyFormat = DateFormat('dd-MM-y', 'id_ID');
final timeFormat = DateFormat('HH:mm:ss', 'id_ID');
final idrCurrencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String evaluateStage(String stage) {
  switch (stage) {
    case scanStage:
      return 'Scan';
    case pickUpStage:
      return 'Ambil Barang';
    case checkStage:
      return 'Checker';
    case packStage:
      return 'Packing';
    case sendStage:
      return 'Kirim';
    case returnStage:
      return 'Retur';
    case cancelStage:
      return 'Cancel';
    default:
      return 'Tidak Diketahui';
  }
}

Future<bool> isInternetConnected() async {
  final connectivity = await Connectivity().checkConnectivity();
  return !connectivity.contains(ConnectivityResult.none);
}

bool isRefreshed<T>(T state, String? refreshToken) {
  return state is RefreshToken && refreshToken != null;
}

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
        constraints: BoxConstraints(minHeight: 48),
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
