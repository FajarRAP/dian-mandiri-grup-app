class ShipmentEntity {
  const ShipmentEntity({
    required this.id,
    required this.courier,
    required this.date,
    required this.receiptNumber,
  });

  final String id;
  final String courier;
  final DateTime date;
  final String receiptNumber;
}
