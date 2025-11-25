import '../../../../core/utils/typedefs.dart';
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

  factory ShipmentHistoryModel.fromJson(JsonMap json) {
    final stages = List<JsonMap>.from(json['stages']);

    return ShipmentHistoryModel(
      id: json['id'],
      receiptNumber: json['receipt_number'],
      courier: json['courier'],
      date: DateTime.parse(json['date']),
      stages: stages.map(StageModel.fromJson).toList(),
    );
  }

  ShipmentHistoryEntity toEntity() {
    return ShipmentHistoryEntity(
      id: id,
      receiptNumber: receiptNumber,
      courier: courier,
      date: date,
      stages: stages.map((stage) => (stage as StageModel).toEntity()).toList(),
    );
  }
}
