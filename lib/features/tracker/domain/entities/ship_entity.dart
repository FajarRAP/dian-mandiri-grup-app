import 'package:intl/intl.dart';

class ShipEntity {
  final int id;
  final String receipt;
  final String name;
  final String stage;
  final String userId;
  final DateTime createdAt;

  ShipEntity({
    required this.id,
    required this.receipt,
    required this.name,
    required this.stage,
    required this.userId,
    required this.createdAt,
  });

  DateTime get syncWithWIB => createdAt.add(const Duration(hours: 7));

  String get formattedDate =>
      DateFormat('dd-MM-y HH:mm:ss').format(syncWithWIB);
}
