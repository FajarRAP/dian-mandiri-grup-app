import '../../domain/entities/shipment_detail_entity.dart';
import 'stage_model.dart';

class ShipmentDetailStatusModel extends ShipmentDetailEntity {
  ShipmentDetailStatusModel({
    required super.id,
    required super.courier,
    required super.document,
    required super.receiptNumber,
    required this.stages,
  });

  final List<StageModel> stages;

  factory ShipmentDetailStatusModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailStatusModel(
        id: json['id'],
        courier: json['courier'],
        document: json['document'],
        receiptNumber: json['receipt_number'],
        stages: List<Map<String, dynamic>>.from(json['stages'])
            .map(StageModel.fromJson)
            .toList(),
      );
}
