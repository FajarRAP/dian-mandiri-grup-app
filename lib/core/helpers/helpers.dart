import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/constants.dart';
import '../exceptions/server_exception.dart';
import '../failure/failure.dart';

extension DateTimeFormatter on DateTime {
  String get toYMD => DateFormat('y-MM-dd', 'id_ID').format(this);
  String get toDMY => DateFormat('dd-MM-y HH:mm:ss', 'id_ID').format(this);
  String get toDMYHMS => DateFormat('dd-MM-y', 'id_ID').format(this);
  String get toHMS => DateFormat('HH:mm:ss', 'id_ID').format(this);
}

extension NumberFormatter on num {
  String get toIDRCurrency =>
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
          .format(this);
}

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
  DataCell mapCell(el) => DataCell(SizedBox(
      width: double.infinity,
      child: Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: el?['error'] ?? '',
          child: Text(el?['value'] ?? ''))));

  final headers = spreadsheetFailure.headers
      .map((e) => DataColumn(label: Text(e)))
      .toList();
  final rows = List.generate(
    spreadsheetFailure.rows.length,
    (index) {
      final row = spreadsheetFailure.rows[index];
      final color = index % 2 == 0 ? Colors.white : Colors.grey.shade50;

      return DataRow(
          color: WidgetStateProperty.all(color),
          cells: row.map(mapCell).toList());
    },
  );

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

ServerException handleDioException(DioException de) {
  final data = de.response?.data;
  final isMap = data is Map<String, dynamic>;

  switch (de.response?.statusCode) {
    default:
      return ServerException(
        message: isMap ? data['message'] : null,
        statusCode: de.response?.statusCode,
      );
  }
}
