import '../../domain/entities/shipment_history_entity.dart';
import 'stage_model.dart';

class ShipmentHistoryModel extends ShipmentHistoryEntity {
  const ShipmentHistoryModel({
    required super.id,
    required super.receiptNumber,
    required super.courier,
    required super.date,
    required super.stages,
  });

  factory ShipmentHistoryModel.fromJson(Map<String, dynamic> json) =>
      ShipmentHistoryModel(
          id: json['id'],
          receiptNumber: json['receipt_number'],
          courier: json['courier'],
          date: DateTime.parse(json['date']),
          stages: List.from(json['stages'])
              .map((e) => StageModel.fromJson(e).toEntity())
              .toList());

  ShipmentHistoryEntity toEntity() => ShipmentHistoryEntity(
      id: id,
      receiptNumber: receiptNumber,
      courier: courier,
      date: date,
      stages: stages);
}
