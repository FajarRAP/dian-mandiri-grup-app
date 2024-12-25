import 'user_entity.dart';

class ShipmentDetailEntity {
  const ShipmentDetailEntity({
    required this.id,
    required this.courier,
    required this.date,
    required this.document,
    required this.receiptNumber,
    required this.stage,
    required this.user,
  });

  final String id;
  final String courier;
  final DateTime date;
  final String? document;
  final String receiptNumber;
  final String stage;
  final UserEntity user;
}
