import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_history_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/insert_shipment_document_use_case.dart';
import '../../domain/usecases/insert_shipment_use_case.dart';
import '../datasources/shipment_remote_data_source.dart';

class ShipmentRepositoryImpl extends ShipmentRepository {
  ShipmentRepositoryImpl({required this.shipmentRemoteDataSource});

  final ShipmentRemoteDataSource shipmentRemoteDataSource;

  @override
  Future<Either<Failure, String>> createShipmentReport(
      {required CreateShipmentReportUseCaseParams params}) async {
    try {
      final result =
          await shipmentRemoteDataSource.createShipmentReport(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> deleteShipment(
      {required String shipmentId}) async {
    try {
      final result =
          await shipmentRemoteDataSource.deleteShipment(shipmentId: shipmentId);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(message: ie.message, statusCode: ie.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> downloadShipmentReport(
      {required DownloadShipmentReportUseCaseParams params}) async {
    try {
      final result =
          await shipmentRemoteDataSource.downloadShipmentReport(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentById(
      {required String shipmentId}) async {
    try {
      final result = await shipmentRemoteDataSource.fetchShipmentById(
          shipmentId: shipmentId);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, ShipmentHistoryEntity>> fetchShipmentByReceiptNumber(
      {required String receiptNumber}) async {
    try {
      final result = await shipmentRemoteDataSource
          .fetchShipmentByReceiptNumber(receiptNumber: receiptNumber);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
    // on DioException catch (de) {
    //   switch (de.response?.statusCode) {
    //     case 404:
    //       return Left(Failure(
    //         message: de.response?.data['message'],
    //         statusCode: 404,
    //       ));
    //     default:
    //       return Left(Failure(message: de.response?.data['message']));
    //   }
    // }
  }

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
      {required FetchShipmentReportsUseCaseParams params}) async {
    try {
      final result =
          await shipmentRemoteDataSource.fetchShipmentReports(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
      {required FetchShipmentsUseCaseParams params}) async {
    try {
      final result =
          await shipmentRemoteDataSource.fetchShipments(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> insertShipment(
      {required InsertShipmentUseCaseParams params}) async {
    try {
      final result =
          await shipmentRemoteDataSource.insertShipment(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    }
    // on DioException catch (de) {
    //   final data = de.response?.data;
    //   switch (de.response?.statusCode) {
    //     case 422:
    //       return Left(Failure(message: data['message'], statusCode: 422));
    //     case 423:
    //       return Left(Failure(message: data['message'], statusCode: 423));
    //     default:
    //       return Left(Failure(message: data['message']));
    //   }
    // }
    on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> insertShipmentDocument(
      {required InsertShipmentDocumentUseCaseParams params}) async {
    try {
      final result =
          await shipmentRemoteDataSource.insertShipmentDocument(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }
}
