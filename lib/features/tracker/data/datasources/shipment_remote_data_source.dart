import 'package:dio/dio.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/network/dio_handler_mixin.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_history_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/delete_shipment_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_by_id_use_case.dart';
import '../../domain/usecases/fetch_shipment_by_receipt_number_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/insert_shipment_document_use_case.dart';
import '../../domain/usecases/insert_shipment_use_case.dart';
import '../models/shipment_detail_model.dart';
import '../models/shipment_history_model.dart';
import '../models/shipment_model.dart';
import '../models/shipment_report_model.dart';

abstract interface class ShipmentRemoteDataSource {
  Future<String> createShipmentReport(CreateShipmentReportUseCaseParams params);
  Future<String> deleteShipment(DeleteShipmentUseCaseParams params);
  Future<String> downloadShipmentReport(
      DownloadShipmentReportUseCaseParams params);
  Future<ShipmentDetailEntity> fetchShipmentById(
      FetchShipmentByIdUseCaseParams params);
  Future<ShipmentHistoryEntity> fetchShipmentByReceiptNumber(
      FetchShipmentByReceiptNumberUseCaseParams params);
  Future<List<ShipmentReportEntity>> fetchShipmentReports(
      FetchShipmentReportsUseCaseParams params);
  Future<List<ShipmentEntity>> fetchShipments(
      FetchShipmentsUseCaseParams params);
  Future<String> insertShipment(InsertShipmentUseCaseParams params);
  Future<String> insertShipmentDocument(
      InsertShipmentDocumentUseCaseParams params);
}

class ShipmentRemoteDataSourceImpl
    with DioHandlerMixin
    implements ShipmentRemoteDataSource {
  const ShipmentRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<String> createShipmentReport(
      CreateShipmentReportUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post(
        '/v1/shipment/report',
        data: {
          'start_date': params.startDate.toYMD,
          'end_date': params.endDate.toYMD,
        },
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> deleteShipment(DeleteShipmentUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.delete('/v1/shipment/${params.shipmentId}');

      return response.data['message'];
    });
  }

  @override
  Future<String> downloadShipmentReport(
      DownloadShipmentReportUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final formattedDate = params.createdAt.toLocal().toDMY;

      await dio.download(
        params.fileUrl,
        '${params.externalPath}/${params.filename}_$formattedDate.xlsx',
      );

      return 'Download completed';
    });
  }

  @override
  Future<ShipmentDetailEntity> fetchShipmentById(
      FetchShipmentByIdUseCaseParams params) async {
    return await handleDioRequest<ShipmentDetailEntity>(() async {
      final response = await dio.get('/v1/shipment/${params.shipmentId}');

      return ShipmentDetailModel.fromJson(response.data['data']).toEntity();
    });
  }

  @override
  Future<ShipmentHistoryEntity> fetchShipmentByReceiptNumber(
      FetchShipmentByReceiptNumberUseCaseParams params) async {
    return await handleDioRequest<ShipmentHistoryEntity>(() async {
      final response =
          await dio.get('/v1/shipment/status/${params.receiptNumber}');

      return ShipmentHistoryModel.fromJson(response.data['data']).toEntity();
    });
  }

  @override
  Future<List<ShipmentReportEntity>> fetchShipmentReports(
      FetchShipmentReportsUseCaseParams params) async {
    return await handleDioRequest<List<ShipmentReportEntity>>(() async {
      final response = await dio.get(
        '/v1/shipment/report',
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
    });
  }

  @override
  Future<List<ShipmentEntity>> fetchShipments(
      FetchShipmentsUseCaseParams params) async {
    return await handleDioRequest<List<ShipmentEntity>>(() async {
      final response = await dio.get(
        '/v1/shipment',
        queryParameters: {
          'date': params.date.toYMD,
          'stage': params.stage,
          'search': params.keyword,
          'page': params.page
        },
      );

      final contents = List.from(response.data['data']['content']);

      return contents.map((e) => ShipmentModel.fromJson(e).toEntity()).toList();
    });
  }

  @override
  Future<String> insertShipment(InsertShipmentUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post(
        '/v1/shipment',
        data: {'receipt_number': params.receiptNumber, 'stage': params.stage},
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> insertShipmentDocument(
      InsertShipmentDocumentUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(params.documentPath),
        'stage': params.stage,
      });

      final response = await dio.post(
        '/v1/shipment/${params.shipmentId}/document',
        data: formData,
      );

      return response.data['message'];
    });
  }
}
