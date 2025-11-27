part of 'shipment_report_cubit.dart';

@immutable
sealed class ShipmentReportState extends Equatable {
  const ShipmentReportState();

  @override
  List<Object?> get props => [];
}

class ShipmentInitial extends ShipmentReportState {}

class FetchShipmentReports extends ShipmentReportState {}

class CreateShipmentReport extends ShipmentReportState {}

class DownloadShipmentReport extends ShipmentReportState {}

class FetchShipmentReportsLoading extends FetchShipmentReports {}

class FetchShipmentReportsLoaded extends FetchShipmentReports {
  FetchShipmentReportsLoaded({required this.shipmentReports});

  final List<ShipmentReportEntity> shipmentReports;
}

class FetchShipmentReportsError extends FetchShipmentReports {
  FetchShipmentReportsError({required this.message});

  final String message;
}

class CreateShipmentReportLoading extends CreateShipmentReport {}

class CreateShipmentReportLoaded extends CreateShipmentReport {
  CreateShipmentReportLoaded({required this.message});

  final String message;
}

class CreateShipmentReportError extends CreateShipmentReport {
  CreateShipmentReportError({required this.message});

  final String message;
}

class DownloadShipmentReportLoading extends DownloadShipmentReport {
  DownloadShipmentReportLoading({required this.shipmentReportId});

  final String shipmentReportId;
}

class DownloadShipmentReportLoaded extends DownloadShipmentReport {
  DownloadShipmentReportLoaded({required this.message});

  final String message;
}

class DownloadShipmentReportError extends DownloadShipmentReport {
  DownloadShipmentReportError({required this.message});

  final String message;
}
