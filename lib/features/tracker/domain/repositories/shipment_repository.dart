import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/shipment_detail_entity.dart';
import '../entities/shipment_entity.dart';
import '../entities/shipment_history_entity.dart';
import '../entities/shipment_report_entity.dart';
import '../usecases/create_shipment_report_use_case.dart';
import '../usecases/delete_shipment_use_case.dart';
import '../usecases/download_shipment_report_use_case.dart';
import '../usecases/fetch_shipment_by_id_use_case.dart';
import '../usecases/fetch_shipment_by_receipt_number_use_case.dart';
import '../usecases/fetch_shipment_reports_use_case.dart';
import '../usecases/fetch_shipments_use_case.dart';
import '../usecases/insert_shipment_document_use_case.dart';
import '../usecases/insert_shipment_use_case.dart';

abstract class ShipmentRepository {
  Future<Either<Failure, String>> createShipmentReport(
      CreateShipmentReportUseCaseParams params);
  Future<Either<Failure, String>> deleteShipment(
      DeleteShipmentUseCaseParams params);
  Future<Either<Failure, String>> downloadShipmentReport(
      DownloadShipmentReportUseCaseParams params);
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentById(
      FetchShipmentByIdUseCaseParams params);
  Future<Either<Failure, ShipmentHistoryEntity>> fetchShipmentByReceiptNumber(
      FetchShipmentByReceiptNumberUseCaseParams params);
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
      FetchShipmentReportsUseCaseParams params);
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
      FetchShipmentsUseCaseParams params);
  Future<Either<Failure, String>> insertShipment(
      InsertShipmentUseCaseParams params);
  Future<Either<Failure, String>> insertShipmentDocument(
      InsertShipmentDocumentUseCaseParams params);
}
