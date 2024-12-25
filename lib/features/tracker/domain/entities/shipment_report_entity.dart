class ShipmentReportEntity {
  const ShipmentReportEntity({
    required this.id,
    required this.date,
    required this.file,
    required this.name,
    required this.status,
  });

  final String id;
  final DateTime date;
  final String file;
  final String name;
  final String status;
}
