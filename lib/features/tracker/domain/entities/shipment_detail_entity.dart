import 'shipment_user_entity.dart';

class ShipmentDetailEntity {
  const ShipmentDetailEntity({
    required this.id,
    required this.courier,
    required this.receiptNumber,
    required this.stage,
    required this.document,
    required this.date,
    required this.user,
  });

  final String id;
  final String courier;
  final String receiptNumber;
  final String stage;
  final String? document;
  final DateTime date;
  final ShipmentUserEntity user;
}
