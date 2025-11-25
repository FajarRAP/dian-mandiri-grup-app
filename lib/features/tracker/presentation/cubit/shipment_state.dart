part of 'shipment_cubit.dart';

@immutable
sealed class ShipmentState {}

class ListPaginate extends ShipmentState {}

class ListPaginateLoading extends ListPaginate {}

class ListPaginateLoaded extends ListPaginate {}

class ListPaginateLast extends ListPaginate {}

final class ShipInitial extends ShipmentState {}

class FetchShipments extends ShipmentState {}

class FetchShipmentDetail extends ShipmentState {}

class InsertShipment extends ShipmentState {}

class InsertShipmentDocument extends ShipmentState {}

class DeleteShipment extends ShipmentState {}

class FetchShipmentReports extends ShipmentState {}

class CreateShipmentReport extends ShipmentState {}

class DownloadShipmentReport extends ShipmentState {}

class FetchReceiptStatus extends ShipmentState {}

class FetchShipmentsLoading extends FetchShipments {}

class FetchShipmentsLoaded extends FetchShipments {
  FetchShipmentsLoaded({required this.shipments});

  final List<ShipmentEntity> shipments;
}

class FetchShipmentsError extends FetchShipments {
  FetchShipmentsError({required this.message});

  final String message;
}

class SearchShipmentsLoaded extends FetchShipments {
  SearchShipmentsLoaded({required this.shipments});

  final List<ShipmentEntity> shipments;
}

class InsertShipmentLoading extends InsertShipment {}

class InsertShipmentLoaded extends InsertShipment {
  InsertShipmentLoaded({required this.message});

  final String message;
}

class InsertShipmentError extends InsertShipment {
  InsertShipmentError({required this.failure});

  final Failure failure;
}

class FetchShipmentDetailLoading extends FetchShipmentDetail {}

class FetchShipmentDetailLoaded extends FetchShipmentDetail {
  FetchShipmentDetailLoaded({required this.shipmentDetail});

  final ShipmentDetailEntity shipmentDetail;
}

class FetchShipmentDetailError extends FetchShipmentDetail {
  FetchShipmentDetailError({required this.message});

  final String message;
}

class InsertShipmentDocumentLoading extends InsertShipmentDocument {}

class InsertShipmentDocumentLoaded extends InsertShipmentDocument {
  InsertShipmentDocumentLoaded({required this.message});

  final String message;
}

class InsertShipmentDocumentError extends InsertShipmentDocument {
  InsertShipmentDocumentError({required this.message});

  final String message;
}

class DeleteShipmentLoading extends DeleteShipment {}

class DeleteShipmentLoaded extends DeleteShipment {
  DeleteShipmentLoaded({required this.message});

  final String message;
}

class DeleteShipmentError extends DeleteShipment {
  DeleteShipmentError({required this.message});

  final String message;
}

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

class FetchReceiptStatusLoading extends FetchReceiptStatus {}

class FetchReceiptStatusLoaded extends FetchReceiptStatus {
  FetchReceiptStatusLoaded({required this.shipmentHistory});

  final ShipmentHistoryEntity shipmentHistory;
}

class FetchReceiptStatusError extends FetchReceiptStatus {
  FetchReceiptStatusError({required this.failure});

  final Failure failure;
}
