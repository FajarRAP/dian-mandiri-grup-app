import 'package:equatable/equatable.dart';

import '../../domain/entities/shipment_report_entity.dart';

class ShipmentReportUiModel extends Equatable {
  const ShipmentReportUiModel({
    required this.entity,
    required this.isDownloaded,
  });

  final ShipmentReportEntity entity;
  final bool isDownloaded;

  ShipmentReportUiModel copyWith({
    ShipmentReportEntity? entity,
    bool? isDownloaded,
  }) {
    return ShipmentReportUiModel(
      entity: entity ?? this.entity,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  @override
  List<Object?> get props => [entity, isDownloaded];
}
