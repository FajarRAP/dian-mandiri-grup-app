import 'package:equatable/equatable.dart';

class ShipmentReportEntity extends Equatable {
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

  String get savedFilename => '$name.xlsx';

  @override
  List<Object?> get props => [id, file, name, status, date];
}
