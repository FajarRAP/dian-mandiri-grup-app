import 'stage_entity.dart';

class ShipmentHistoryEntity {
  const ShipmentHistoryEntity({
    required this.id,
    required this.receiptNumber,
    required this.courier,
    required this.date,
    required this.stages,
  });

  final String id;
  final String receiptNumber;
  final String courier;
  final DateTime date;
  final List<StageEntity> stages;
}
