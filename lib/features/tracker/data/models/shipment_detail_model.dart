import '../../domain/entities/shipment_detail_entity.dart';
import 'user_model.dart';

class ShipmentDetailModel extends ShipmentDetailEntity {
  const ShipmentDetailModel({
    required super.id,
    required super.courier,
    required super.date,
    required super.document,
    required super.receiptNumber,
    required super.stage,
    required super.user,
  });

  factory ShipmentDetailModel.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailModel(
          id: json['id'],
          courier: json['courier'],
          date: DateTime.parse(json['date']),
          document: json['document'],
          receiptNumber: json['receipt_number'],
          stage: json['stage'],
          user: UserModel.fromJson(json['user']));
}
