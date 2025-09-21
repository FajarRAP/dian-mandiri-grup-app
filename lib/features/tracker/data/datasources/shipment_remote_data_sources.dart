import 'package:dio/dio.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/helpers/helpers.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_history_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/insert_shipment_document_use_case.dart';
import '../../domain/usecases/insert_shipment_use_case.dart';
import '../models/shipment_detail_model.dart';
import '../models/shipment_history_model.dart';
import '../models/shipment_model.dart';
import '../models/shipment_report_model.dart';

abstract class ShipmentRemoteDataSources {
  Future<String> createShipmentReport(
      {required CreateShipmentReportUseCaseParams params});
  Future<String> deleteShipment({required String shipmentId});
  Future<String> downloadShipmentReport(
      {required DownloadShipmentReportUseCaseParams params});
  Future<ShipmentDetailEntity> fetchShipmentById({required String shipmentId});
  Future<ShipmentHistoryEntity> fetchShipmentByReceiptNumber(
      {required String receiptNumber});
  Future<List<ShipmentReportEntity>> fetchShipmentReports(
      {required FetchShipmentReportsUseCaseParams params});
  Future<List<ShipmentEntity>> fetchShipments(
      {required FetchShipmentsUseCaseParams params});
  Future<String> insertShipment({required InsertShipmentUseCaseParams params});
  Future<String> insertShipmentDocument(
      {required InsertShipmentDocumentUseCaseParams params});
}

class ShipmentRemoteDataSourcesImpl extends ShipmentRemoteDataSources {
  ShipmentRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<String> createShipmentReport(
      {required CreateShipmentReportUseCaseParams params}) async {
    try {
      final response = await dio.post(
        '$shipmentEndpoint/report',
        data: {
          'start_date': params.startDate.toYMD,
          'end_date': params.endDate.toYMD,
        },
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> deleteShipment({required String shipmentId}) async {
    try {
      final response = await dio.delete('$shipmentEndpoint/$shipmentId');

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> downloadShipmentReport(
      {required DownloadShipmentReportUseCaseParams params}) async {
    try {
      final formattedDate = params.createdAt.toLocal().toDMY;

      await dio.download(
        params.fileUrl,
        '${params.externalPath}/${params.filename}_$formattedDate.xlsx',
      );

      return 'Download completed';
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<ShipmentDetailEntity> fetchShipmentById(
      {required String shipmentId}) async {
    try {
      final response = await dio.get('$shipmentEndpoint/$shipmentId');

      return ShipmentDetailModel.fromJson(response.data['data']).toEntity();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<ShipmentHistoryEntity> fetchShipmentByReceiptNumber(
      {required String receiptNumber}) async {
    try {
      final response = await dio.get('$shipmentEndpoint/status/$receiptNumber');

      return ShipmentHistoryModel.fromJson(response.data['data']).toEntity();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<ShipmentReportEntity>> fetchShipmentReports(
      {required FetchShipmentReportsUseCaseParams params}) async {
    try {
      final response = await dio.get(
        '$shipmentEndpoint/report',
        queryParameters: {
          'start_date': params.startDate.toYMD,
          'end_date': params.endDate.toYMD,
          'status': params.status,
          'page': params.page,
        },
      );

      final contents = List.from(response.data['data']['content']);

      return contents
          .map((e) => ShipmentReportModel.fromJson(e).toEntity())
          .toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<ShipmentEntity>> fetchShipments(
      {required FetchShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.get(
        shipmentEndpoint,
        queryParameters: {
          'date': params.date.toYMD,
          'stage': params.stage,
          'search': params.keyword,
          'page': params.page
        },
      );

      final contents = List.from(response.data['data']['content']);

      return contents.map((e) => ShipmentModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> insertShipment(
      {required InsertShipmentUseCaseParams params}) async {
    try {
      final response = await dio.post(
        shipmentEndpoint,
        data: {'receipt_number': params.receiptNumber, 'stage': params.stage},
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> insertShipmentDocument(
      {required InsertShipmentDocumentUseCaseParams params}) async {
    try {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(params.documentPath),
        'stage': params.stage,
      });

      final response = await dio.post(
        '$shipmentEndpoint/${params.shipmentId}/document',
        data: formData,
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
