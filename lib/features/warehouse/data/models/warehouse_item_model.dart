import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/warehouse_item_entity.dart';

class WarehouseItemModel extends WarehouseItemEntity {
  const WarehouseItemModel({
    super.id,
    super.shipmentFee,
    required super.name,
    required super.quantity,
    required super.rejectQuantity,
    required super.price,
  });

  factory WarehouseItemModel.fromJson(JsonMap json) {
    return WarehouseItemModel(
      id: json['id'],
      shipmentFee: json['shipment_price'],
      name: json['name'],
      quantity: json['total'],
      rejectQuantity: json['total_reject'],
      price: json['price'],
    );
  }

  factory WarehouseItemModel.fromEntity(WarehouseItemEntity entity) {
    return WarehouseItemModel(
      id: entity.id,
      shipmentFee: entity.shipmentFee,
      name: entity.name,
      quantity: entity.quantity,
      rejectQuantity: entity.rejectQuantity,
      price: entity.price,
    );
  }

  JsonMap toJson() {
    return {
      'name': name,
      'total': quantity,
      'total_reject': rejectQuantity,
      'price': price,
    };
  }

  WarehouseItemEntity toEntity() {
    return WarehouseItemEntity(
      id: id,
      shipmentFee: shipmentFee,
      name: name,
      quantity: quantity,
      rejectQuantity: rejectQuantity,
      price: price,
    );
  }
}
