import '../../domain/entities/shipment_entity.dart';

class ShipmentModel extends ShipmentEntity {
  const ShipmentModel({
    required super.id,
    required super.courier,
    required super.date,
    required super.receiptNumber,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) => ShipmentModel(
      id: json['id'],
      courier: json['courier'],
      date: DateTime.parse(json['date']),
      receiptNumber: json['receipt_number']);
}
