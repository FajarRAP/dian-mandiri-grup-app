import '../../domain/entities/shipment_report_entity.dart';

class ShipmentReportModel extends ShipmentReportEntity {
  const ShipmentReportModel({
    required super.id,
    required super.date,
    required super.file,
    required super.name,
    required super.status,
  });

  factory ShipmentReportModel.fromEntity(ShipmentReportEntity shipmentReport) =>
      ShipmentReportModel(
        id: shipmentReport.id,
        date: shipmentReport.date,
        file: shipmentReport.file,
        name: shipmentReport.name,
        status: shipmentReport.status,
      );

  factory ShipmentReportModel.fromJson(Map<String, dynamic> json) =>
      ShipmentReportModel(
          id: json['id'],
          date: DateTime.parse(json['date']),
          file: json['file'],
          name: json['name'],
          status: json['status']);
}
