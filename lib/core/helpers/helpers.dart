import 'package:intl/intl.dart';

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
