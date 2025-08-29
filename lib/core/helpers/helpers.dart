import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../failure/failure.dart';

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

List parseSpreadsheetFailure(SpreadsheetFailure spreadsheetFailure) {
  final headers = spreadsheetFailure.headers
      .map((e) => DataColumn(label: Text(e)))
      .toList();
  final rows = spreadsheetFailure.rows
      .map((e) => DataRow(
          cells: e.map((el) => DataCell(Text(el?['value'] ?? ''))).toList()))
      .toList();

  return [headers, rows];
}

class TextFormFieldConfig {
  const TextFormFieldConfig({
    this.onFieldSubmitted,
    this.autoFocus,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
  });

  final void Function(String value)? onFieldSubmitted;
  final bool? autoFocus;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
}
