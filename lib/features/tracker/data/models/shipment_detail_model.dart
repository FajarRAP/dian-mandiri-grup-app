import '../../../../core/utils/typedefs.dart';
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

  factory ShipmentDetailModel.fromJson(JsonMap json) {
    return ShipmentDetailModel(
      id: json['id'],
      courier: json['courier'],
      receiptNumber: json['receipt_number'],
      stage: json['stage'],
      document: json['document'],
      date: DateTime.parse(json['date']),
      user: ShipmentUserModel.fromJson(json['user']),
    );
  }

  ShipmentDetailEntity toEntity() {
    return ShipmentDetailEntity(
      id: id,
      courier: courier,
      receiptNumber: receiptNumber,
      stage: stage,
      document: document,
      date: date,
      user: (user as ShipmentUserModel).toEntity(),
    );
  }
}
