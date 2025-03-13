class ShipmentDetailEntity {
  const ShipmentDetailEntity({
    required this.id,
    required this.courier,
    required this.document,
    required this.receiptNumber,
  });

  final String id;
  final String courier;
  final String? document;
  final String receiptNumber;
}
