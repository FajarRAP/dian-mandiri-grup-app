import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/shipment_detail_entity.dart';
import '../entities/shipment_entity.dart';
import '../entities/shipment_history_entity.dart';
import '../entities/shipment_report_entity.dart';
import '../usecases/create_shipment_report_use_case.dart';
import '../usecases/delete_shipment_use_case.dart';
import '../usecases/download_shipment_report_use_case.dart';
import '../usecases/fetch_shipment_use_case.dart';
import '../usecases/fetch_shipment_status_use_case.dart';
import '../usecases/fetch_shipment_reports_use_case.dart';
import '../usecases/fetch_shipments_use_case.dart';
import '../usecases/update_shipment_document_use_case.dart';
import '../usecases/create_shipment_use_case.dart';

abstract class ShipmentRepository {
  // Shipment List
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
    FetchShipmentsUseCaseParams params,
  );
  Future<Either<Failure, String>> createShipment(
    CreateShipmentUseCaseParams params,
  );
  Future<Either<Failure, String>> deleteShipment(
    DeleteShipmentUseCaseParams params,
  );
  // Shipment Detail
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipment(
    FetchShipmentUseCaseParams params,
  );
  Future<Either<Failure, String>> updateShipmentDocument(
    UpdateShipmentDocumentUseCaseParams params,
  );
  Future<Either<Failure, ShipmentHistoryEntity>> fetchShipmentStatus(
    FetchShipmentStatusUseCaseParams params,
  );
  // Shipment Report
  Future<Either<Failure, String>> createShipmentReport(
    CreateShipmentReportUseCaseParams params,
  );
  Future<Either<Failure, String>> downloadShipmentReport(
    DownloadShipmentReportUseCaseParams params,
  );
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
    FetchShipmentReportsUseCaseParams params,
  );
}
