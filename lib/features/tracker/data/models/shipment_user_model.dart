import '../../domain/entities/shipment_user_entity.dart';

class ShipmentUserModel extends ShipmentUserEntity {
  const ShipmentUserModel({
    required super.id,
    required super.name,
  });

  factory ShipmentUserModel.fromJson(Map<String, dynamic> json) =>
      ShipmentUserModel(id: json['id'], name: json['name']);

  ShipmentUserEntity toEntity() => ShipmentUserEntity(id: id, name: name);
}
