import 'shipment_user_entity.dart';

class StageEntity {
  const StageEntity({
    required this.stage,
    required this.date,
    required this.user,
    required this.document,
  });

  final String stage;
  final String? document;
  final DateTime date;
  final ShipmentUserEntity user;
}
