class WarehouseItemEntity {
  const WarehouseItemEntity({
    this.id,
    this.shipmentFee,
    required this.name,
    required this.quantity,
    required this.rejectQuantity,
    required this.price,
  });

  final String? id;
  final num? shipmentFee;
  final String name;
  final int quantity;
  final int rejectQuantity;
  final num price;
}
