import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/shipment_user_entity.dart';

class ShipmentUserModel extends ShipmentUserEntity {
  const ShipmentUserModel({
    required super.id,
    required super.name,
  });

  factory ShipmentUserModel.fromJson(JsonMap json) {
    return ShipmentUserModel(id: json['id'], name: json['name']);
  }

  ShipmentUserEntity toEntity() {
    return ShipmentUserEntity(id: id, name: name);
  }
}
