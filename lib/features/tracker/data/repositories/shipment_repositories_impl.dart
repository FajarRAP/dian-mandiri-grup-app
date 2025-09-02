import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/repositories/shipment_repositories.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/insert_shipment_document_use_case.dart';
import '../../domain/usecases/insert_shipment_use_case.dart';
import '../datasources/shipment_remote_data_sources.dart';
import '../models/shipment_detail_model.dart';
import '../models/shipment_detail_status_model.dart';
import '../models/shipment_model.dart';
import '../models/shipment_report_model.dart';

class ShipmentRepositoriesImpl extends ShipmentRepositories {
  ShipmentRepositoriesImpl({required this.shipmentRemoteDataSources});

  final ShipmentRemoteDataSources<Response> shipmentRemoteDataSources;

  @override
  Future<Either<Failure, String>> createShipmentReport(
      {required CreateShipmentReportUseCaseParams params}) async {
    try {
      final response =
          await shipmentRemoteDataSources.createShipmentReport(params: params);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteShipment(
      {required String shipmentId}) async {
    try {
      final response = await shipmentRemoteDataSources.deleteShipment(
          shipmentId: shipmentId);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadShipmentReport(
      {required DownloadShipmentReportUseCaseParams params}) async {
    try {
      await shipmentRemoteDataSources.downloadShipmentReport(params: params);

      return const Right('Berhasil mengunduh laporan');
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentById(
      {required String shipmentId}) async {
    try {
      final response = await shipmentRemoteDataSources.fetchShipmentById(
          shipmentId: shipmentId);

      return Right(ShipmentDetailModel.fromJson(response.data['data']));
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentByReceiptNumber(
      {required String receiptNumber}) async {
    try {
      final response = await shipmentRemoteDataSources
          .fetchShipmentByReceiptNumber(receiptNumber: receiptNumber);

      return Right(ShipmentDetailStatusModel.fromJson(response.data['data']));
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 404:
          return Left(Failure(
            message: de.response?.data['message'],
            statusCode: 404,
          ));
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
      {required FetchShipmentReportsUseCaseParams params}) async {
    try {
      final response =
          await shipmentRemoteDataSources.fetchShipmentReports(params: params);
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(contents.map(ShipmentReportModel.fromJson).toList());
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
      {required FetchShipmentsUseCaseParams params}) async {
    try {
      final response =
          await shipmentRemoteDataSources.fetchShipments(params: params);
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(contents.map(ShipmentModel.fromJson).toList());
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertShipment(
      {required InsertShipmentUseCaseParams params}) async {
    try {
      final response =
          await shipmentRemoteDataSources.insertShipment(params: params);

      return Right(response.data['message']);
    } on DioException catch (de) {
      final data = de.response?.data;
      switch (de.response?.statusCode) {
        case 422:
          return Left(Failure(message: data['message'], statusCode: 422));
        case 423:
          return Left(Failure(message: data['message'], statusCode: 423));
        default:
          return Left(Failure(message: data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertShipmentDocument(
      {required InsertShipmentDocumentUseCaseParams params}) async {
    try {
      final response = await shipmentRemoteDataSources.insertShipmentDocument(
          params: params);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return Left(Failure(message: '$e'));
    }
  }
}
