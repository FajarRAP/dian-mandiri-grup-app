import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/utils/respository_handler_mixin.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_history_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/delete_shipment_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_by_id_use_case.dart';
import '../../domain/usecases/fetch_shipment_by_receipt_number_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/insert_shipment_document_use_case.dart';
import '../../domain/usecases/insert_shipment_use_case.dart';
import '../datasources/shipment_remote_data_source.dart';

class ShipmentRepositoryImpl
    with RepositoryHandlerMixin
    implements ShipmentRepository {
  const ShipmentRepositoryImpl({required this.shipmentRemoteDataSource});

  final ShipmentRemoteDataSource shipmentRemoteDataSource;

  @override
  Future<Either<Failure, String>> createShipmentReport(
      CreateShipmentReportUseCaseParams params) async {
    return await handleRepositoryRequest<String>(() async {
      final result =
          await shipmentRemoteDataSource.createShipmentReport(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> deleteShipment(
      DeleteShipmentUseCaseParams params) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await shipmentRemoteDataSource.deleteShipment(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> downloadShipmentReport(
      DownloadShipmentReportUseCaseParams params) async {
    return await handleRepositoryRequest<String>(() async {
      final result =
          await shipmentRemoteDataSource.downloadShipmentReport(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentById(
      FetchShipmentByIdUseCaseParams params) async {
    return await handleRepositoryRequest<ShipmentDetailEntity>(() async {
      final result = await shipmentRemoteDataSource.fetchShipmentById(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, ShipmentHistoryEntity>> fetchShipmentByReceiptNumber(
      FetchShipmentByReceiptNumberUseCaseParams params) async {
    return await handleRepositoryRequest<ShipmentHistoryEntity>(() async {
      final result =
          await shipmentRemoteDataSource.fetchShipmentByReceiptNumber(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
      FetchShipmentReportsUseCaseParams params) async {
    return await handleRepositoryRequest<List<ShipmentReportEntity>>(() async {
      final result =
          await shipmentRemoteDataSource.fetchShipmentReports(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
      FetchShipmentsUseCaseParams params) async {
    return await handleRepositoryRequest<List<ShipmentEntity>>(() async {
      final result = await shipmentRemoteDataSource.fetchShipments(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> insertShipment(
      InsertShipmentUseCaseParams params) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await shipmentRemoteDataSource.insertShipment(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> insertShipmentDocument(
      InsertShipmentDocumentUseCaseParams params) async {
    return await handleRepositoryRequest<String>(() async {
      final result =
          await shipmentRemoteDataSource.insertShipmentDocument(params);

      return result;
    });
  }
}
