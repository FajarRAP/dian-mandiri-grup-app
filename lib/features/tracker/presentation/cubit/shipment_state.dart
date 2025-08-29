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
  final List<ShipmentEntity> shipments;

  FetchShipmentsLoaded({required this.shipments});
}

class FetchShipmentsError extends FetchShipments {
  final String message;

  FetchShipmentsError({required this.message});
}

class SearchShipmentsLoaded extends FetchShipments {
  final List<ShipmentEntity> shipments;

  SearchShipmentsLoaded({required this.shipments});
}

class InsertShipmentLoading extends InsertShipment {}

class InsertShipmentLoaded extends InsertShipment {
  final String message;

  InsertShipmentLoaded({required this.message});
}

class InsertShipmentError extends InsertShipment {
  final Failure failure;

  InsertShipmentError({required this.failure});
}

class FetchShipmentDetailLoading extends FetchShipmentDetail {}

class FetchShipmentDetailLoaded extends FetchShipmentDetail {
  final ShipmentDetailEntity shipmentDetail;

  FetchShipmentDetailLoaded({required this.shipmentDetail});
}

class FetchShipmentDetailError extends FetchShipmentDetail {
  final String message;

  FetchShipmentDetailError({required this.message});
}

class InsertShipmentDocumentLoading extends InsertShipmentDocument {}

class InsertShipmentDocumentLoaded extends InsertShipmentDocument {
  final String message;

  InsertShipmentDocumentLoaded({required this.message});
}

class InsertShipmentDocumentError extends InsertShipmentDocument {
  final String message;

  InsertShipmentDocumentError({required this.message});
}

class DeleteShipmentLoading extends DeleteShipment {}

class DeleteShipmentLoaded extends DeleteShipment {
  final String message;

  DeleteShipmentLoaded({required this.message});
}

class DeleteShipmentError extends DeleteShipment {
  final String message;

  DeleteShipmentError({required this.message});
}

class FetchShipmentReportsLoading extends FetchShipmentReports {}

class FetchShipmentReportsLoaded extends FetchShipmentReports {
  final List<ShipmentReportEntity> shipmentReports;

  FetchShipmentReportsLoaded({required this.shipmentReports});
}

class FetchShipmentReportsError extends FetchShipmentReports {
  final String message;

  FetchShipmentReportsError({required this.message});
}

class CreateShipmentReportLoading extends CreateShipmentReport {}

class CreateShipmentReportLoaded extends CreateShipmentReport {
  final String message;

  CreateShipmentReportLoaded({required this.message});
}

class CreateShipmentReportError extends CreateShipmentReport {
  final String message;

  CreateShipmentReportError({required this.message});
}

class DownloadShipmentReportLoading extends DownloadShipmentReport {}

class DownloadShipmentReportLoaded extends DownloadShipmentReport {
  final String message;

  DownloadShipmentReportLoaded({required this.message});
}

class DownloadShipmentReportError extends DownloadShipmentReport {
  final String message;

  DownloadShipmentReportError({required this.message});
}

class FetchReceiptStatusLoading extends FetchReceiptStatus {}

class FetchReceiptStatusLoaded extends FetchReceiptStatus {
  final ShipmentDetailEntity shipmentDetail;

  FetchReceiptStatusLoaded({required this.shipmentDetail});
}

class FetchReceiptStatusError extends FetchReceiptStatus {
  final Failure failure;

  FetchReceiptStatusError({required this.failure});
}
