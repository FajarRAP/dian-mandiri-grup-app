class ShipmentReportEntity {
  const ShipmentReportEntity({
    required this.id,
    required this.file,
    required this.name,
    required this.status,
    required this.date,
  });

  final String id;
  final String file;
  final String name;
  final String status;
  final DateTime date;
}
