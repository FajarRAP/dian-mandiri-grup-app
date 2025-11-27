import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../errors/failure.dart';

extension DateTimeFormatter on DateTime {
  String get toYMD => DateFormat('y-MM-dd', 'id_ID').format(this);
  String get toDMY => DateFormat('dd-MM-y', 'id_ID').format(this);
  String get toDMYHMS => DateFormat('dd-MM-y HH:mm:ss', 'id_ID').format(this);
  String get toHMS => DateFormat('HH:mm:ss', 'id_ID').format(this);
}

extension NumberFormatter on num {
  String get toIDRCurrency => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(this);
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

List parseSpreadsheetFailure(SpreadsheetFailure spreadsheetFailure) {
  DataCell mapCell(el) => DataCell(
    SizedBox(
      width: double.infinity,
      child: Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        message: el?['error'] ?? '',
        child: Text(el?['value'] ?? ''),
      ),
    ),
  );

  final headers = spreadsheetFailure.headers
      .map((e) => DataColumn(label: Text(e)))
      .toList();
  final rows = List.generate(spreadsheetFailure.rows.length, (index) {
    final row = spreadsheetFailure.rows[index];
    final color = index % 2 == 0 ? Colors.white : Colors.grey.shade50;

    return DataRow(
      color: WidgetStateProperty.all(color),
      cells: row.map(mapCell).toList(),
    );
  });

  return [headers, rows];
}

class TextFormFieldConfig {
  const TextFormFieldConfig({
    this.onFieldSubmitted,
    this.autoFocus = false,
    this.decoration,
    this.keyboardType = .text,
    this.textInputAction = .send,
  });

  TextFormFieldConfig copyWith({
    final void Function(String value)? onFieldSubmitted,
    final bool? autoFocus,
    final InputDecoration? decoration,
    final TextInputType? keyboardType,
    final TextInputAction? textInputAction,
  }) {
    return TextFormFieldConfig(
      onFieldSubmitted: onFieldSubmitted ?? this.onFieldSubmitted,
      autoFocus: autoFocus ?? this.autoFocus,
      decoration: decoration ?? this.decoration,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
    );
  }

  final void Function(String value)? onFieldSubmitted;
  final bool autoFocus;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
}
