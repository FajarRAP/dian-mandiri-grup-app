import '../../domain/entities/shipment_detail_entity.dart';
import 'stage_model.dart';
import 'user_model.dart';

class ShipmentDetailModel extends ShipmentDetailEntity {
  const ShipmentDetailModel({
    required super.id,
    required super.courier,
    required super.document,
    required super.receiptNumber,
    required this.stage,
  });

  final StageModel stage;

  factory ShipmentDetailModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailModel(
        id: json['id'],
        courier: json['courier'],
        document: json['document'],
        receiptNumber: json['receipt_number'],
        stage: StageModel(
          stage: json['stage'],
          date: DateTime.parse(json['date']),
          user: UserModel.fromJson(json['user']),
        ),
      );
}
