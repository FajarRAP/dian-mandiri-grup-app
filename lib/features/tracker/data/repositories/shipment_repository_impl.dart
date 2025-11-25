import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/respository_handler_mixin.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_history_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/delete_shipment_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_use_case.dart';
import '../../domain/usecases/fetch_shipment_status_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/update_shipment_document_use_case.dart';
import '../../domain/usecases/create_shipment_use_case.dart';
import '../datasources/shipment_remote_data_source.dart';

class ShipmentRepositoryImpl
    with RepositoryHandlerMixin
    implements ShipmentRepository {
  const ShipmentRepositoryImpl({required this.shipmentRemoteDataSource});

  final ShipmentRemoteDataSource shipmentRemoteDataSource;

  @override
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
    FetchShipmentsUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<List<ShipmentEntity>>(() async {
      final result = await shipmentRemoteDataSource.fetchShipments(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> createShipment(
    CreateShipmentUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await shipmentRemoteDataSource.createShipment(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> deleteShipment(
    DeleteShipmentUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await shipmentRemoteDataSource.deleteShipment(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipment(
    FetchShipmentUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<ShipmentDetailEntity>(() async {
      final result = await shipmentRemoteDataSource.fetchShipment(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> updateShipmentDocument(
    UpdateShipmentDocumentUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await shipmentRemoteDataSource.updateShipmentDocument(
        params,
      );

      return result;
    });
  }

  @override
  Future<Either<Failure, ShipmentHistoryEntity>> fetchShipmentStatus(
    FetchShipmentStatusUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<ShipmentHistoryEntity>(() async {
      final result = await shipmentRemoteDataSource.fetchShipmentStatus(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> createShipmentReport(
    CreateShipmentReportUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await shipmentRemoteDataSource.createShipmentReport(
        params,
      );

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> downloadShipmentReport(
    DownloadShipmentReportUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await shipmentRemoteDataSource.downloadShipmentReport(
        params,
      );

      return result;
    });
  }

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
    FetchShipmentReportsUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<List<ShipmentReportEntity>>(() async {
      final result = await shipmentRemoteDataSource.fetchShipmentReports(
        params,
      );

      return result;
    });
  }
}
