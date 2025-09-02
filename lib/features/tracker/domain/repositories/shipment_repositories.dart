import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/shipment_detail_entity.dart';
import '../entities/shipment_entity.dart';
import '../entities/shipment_report_entity.dart';
import '../usecases/create_shipment_report_use_case.dart';
import '../usecases/download_shipment_report_use_case.dart';
import '../usecases/fetch_shipment_reports_use_case.dart';
import '../usecases/fetch_shipments_use_case.dart';
import '../usecases/insert_shipment_document_use_case.dart';
import '../usecases/insert_shipment_use_case.dart';

abstract class ShipmentRepositories {
  Future<Either<Failure, String>> createShipmentReport(
      {required CreateShipmentReportUseCaseParams params});
  Future<Either<Failure, String>> deleteShipment({required String shipmentId});
  Future<Either<Failure, String>> downloadShipmentReport(
      {required DownloadShipmentReportUseCaseParams params});
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentById(
      {required String shipmentId});
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentByReceiptNumber(
      {required String receiptNumber});
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
      {required FetchShipmentReportsUseCaseParams params});
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
      {required FetchShipmentsUseCaseParams params});
  Future<Either<Failure, String>> insertShipment(
      {required InsertShipmentUseCaseParams params});
  Future<Either<Failure, String>> insertShipmentDocument(
      {required InsertShipmentDocumentUseCaseParams params});
}
