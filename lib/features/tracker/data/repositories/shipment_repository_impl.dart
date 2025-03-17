import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/exceptions/refresh_token.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../datasources/shipment_remote_data_source.dart';
import '../models/shipment_detail_model.dart';
import '../models/shipment_detail_status_model.dart';
import '../models/shipment_model.dart';
import '../models/shipment_report_model.dart';

class ShipmentRepositoryImpl extends ShipmentRepository {
  ShipmentRepositoryImpl({required this.shipmentRemoteDataSource});

  final ShipmentRemoteDataSource<Response> shipmentRemoteDataSource;

  @override
  Future<Either<Failure, String>> createShipmentReport(
      {required String startDate, required String endDate}) async {
    try {
      final response = await shipmentRemoteDataSource.createShipmentReport(
          startDate: startDate, endDate: endDate);
      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
          await shipmentRemoteDataSource.deleteShipment(shipmentId: shipmentId);
      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
      final response = await shipmentRemoteDataSource.fetchShipmentById(
          shipmentId: shipmentId);
      return Right(ShipmentDetailModel.fromJson(response.data['data']));
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
      final response = await shipmentRemoteDataSource
          .fetchShipmentByReceiptNumber(receiptNumber: receiptNumber);
      return Right(ShipmentDetailStatusModel.fromJson(response.data['data']));
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
      final response = await shipmentRemoteDataSource.fetchShipmentReports(
          startDate: startDate, endDate: endDate, status: status);
      final contents = response.data['data']['content'] as List;
      return Right(
          contents.map((e) => ShipmentReportModel.fromJson(e)).toList());
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
  Future<Either<Failure, Map<String, dynamic>>> fetchShipments(
      {required String date,
      required String stage,
      int page = 1,
      String? keyword}) async {
    try {
      final response = await shipmentRemoteDataSource.fetchShipments(
          date: date, stage: stage, page: page, keyword: keyword);
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);
      final shipments = contents.map(ShipmentModel.fromJson).toList();
      final totalPage = response.data['data']['metadata']['total_page'];
      return Right({'shipments': shipments, 'totalPage': totalPage});
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
      final response = await shipmentRemoteDataSource.insertShipment(
          receiptNumber: receiptNumber, stage: stage);
      return Right(response.data['message']);
    } on DioException catch (de) {
      final data = de.response?.data;
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
      required XFile document,
      required String stage}) async {
    try {
      final response = await shipmentRemoteDataSource.insertShipmentDocument(
          shipmentId: shipmentId, document: document, stage: stage);
      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
      await shipmentRemoteDataSource.downloadShipmentReport(
          shipmentReportModel: model);

      return const Right('Berhasil mengunduh laporan');
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 401:
          return Left(RefreshToken());
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
