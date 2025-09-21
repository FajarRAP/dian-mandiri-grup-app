import '../../domain/entities/shipment_detail_entity.dart';
import 'shipment_user_model.dart';

class ShipmentDetailModel extends ShipmentDetailEntity {
  const ShipmentDetailModel({
    required super.id,
    required super.courier,
    required super.receiptNumber,
    required super.stage,
    required super.document,
    required super.date,
    required super.user,
  });

  factory ShipmentDetailModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailModel(
        id: json['id'],
        courier: json['courier'],
        receiptNumber: json['receipt_number'],
        stage: json['stage'],
        document: json['document'],
        date: DateTime.parse(json['date']),
        user: ShipmentUserModel.fromJson(json['user']).toEntity(),
      );

  ShipmentDetailEntity toEntity() => ShipmentDetailEntity(
      id: id,
      courier: courier,
      receiptNumber: receiptNumber,
      stage: stage,
      document: document,
      date: date,
      user: user);
}
