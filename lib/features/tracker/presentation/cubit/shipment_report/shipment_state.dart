part of 'shipment_cubit.dart';

@immutable
sealed class ShipmentState extends Equatable {
  const ShipmentState();

  @override
  List<Object?> get props => [];
}

class ShipmentInitial extends ShipmentState {}

class FetchShipmentReports extends ShipmentState {}

class CreateShipmentReport extends ShipmentState {}

class DownloadShipmentReport extends ShipmentState {}

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
