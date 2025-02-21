import '../../domain/entities/shipment_detail_entity.dart';
import 'stage_model.dart';
import 'user_model.dart';

class ShipmentDetailStatusModel extends ShipmentDetailEntity {
  ShipmentDetailStatusModel({
    required super.id,
    required super.courier,
    required super.document,
    required super.receiptNumber,
    required super.user,
    required this.stages,
  });

  final List<StageModel> stages;

  factory ShipmentDetailStatusModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailStatusModel(
          id: json['id'],
          courier: json['courier'],
          document: json['document'],
          receiptNumber: json['receipt_number'],
          stages: (json['stages'] as List)
              .map((e) => StageModel.fromJson(e))
              .toList(),
          user: UserModel.fromJson(json['user']));
}
