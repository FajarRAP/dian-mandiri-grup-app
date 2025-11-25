import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/shipment_report_entity.dart';

class ShipmentReportModel extends ShipmentReportEntity {
  const ShipmentReportModel({
    required super.id,
    required super.file,
    required super.name,
    required super.status,
    required super.date,
  });

  factory ShipmentReportModel.fromJson(JsonMap json) {
    return ShipmentReportModel(
        id: json['id'],
        date: DateTime.parse(json['date']),
        file: json['file'],
        name: json['name'],
        status: json['status']);
  }

  ShipmentReportEntity toEntity() {
    return ShipmentReportEntity(
      id: id,
      file: file,
      name: name,
      status: status,
      date: date,
    );
  }
}
