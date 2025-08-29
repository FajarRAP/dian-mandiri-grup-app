import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/repositories/shipment_repositories.dart';
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
      {required String startDate, required String endDate}) async {
    try {
      final response = await shipmentRemoteDataSources.createShipmentReport(
          startDate: startDate, endDate: endDate);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteShipment(
      {required String shipmentId}) async {
    try {
      final response =
          await shipmentRemoteDataSources.deleteShipment(shipmentId: shipmentId);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
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
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
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
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
      {required String startDate,
      required String endDate,
      required String status}) async {
    try {
      final response = await shipmentRemoteDataSources.fetchShipmentReports(
          startDate: startDate, endDate: endDate, status: status);
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(contents.map(ShipmentReportModel.fromJson).toList());
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
      {required String date,
      required String stage,
      int page = 1,
      String? keyword}) async {
    try {
      final response = await shipmentRemoteDataSources.fetchShipments(
          date: date, stage: stage, page: page, keyword: keyword);
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(contents.map(ShipmentModel.fromJson).toList());
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertShipment(
      {required String receiptNumber, required String stage}) async {
    try {
      final response = await shipmentRemoteDataSources.insertShipment(
          receiptNumber: receiptNumber, stage: stage);

      return Right(response.data['message']);
    } on DioException catch (de) {
      final data = de.response?.data;
      switch (de.response?.statusCode) {
        case 422:
          return Left(Failure(message: data['message'], statusCode: 422));
        case 423:
          return Left(Failure(message: data['message'], statusCode: 423));
        default:
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> insertShipmentDocument(
      {required String shipmentId,
      required String documentPath,
      required String stage}) async {
    try {
      final response = await shipmentRemoteDataSources.insertShipmentDocument(
          shipmentId: shipmentId, documentPath: documentPath, stage: stage);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadShipmentReport(
      {required ShipmentReportEntity shipmentReportEntity}) async {
    try {
      final model = ShipmentReportModel.fromEntity(shipmentReportEntity);
      await shipmentRemoteDataSources.downloadShipmentReport(
          shipmentReportModel: model);

      return const Right('Berhasil mengunduh laporan');
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          return kReleaseMode || kProfileMode
              ? const Left(Failure())
              : Left(Failure(message: de.response?.data['message']));
      }
    } catch (e) {
      return kReleaseMode || kProfileMode
          ? const Left(Failure())
          : Left(Failure(message: '$e'));
    }
  }
}
