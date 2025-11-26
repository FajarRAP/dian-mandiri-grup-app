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
import '../../domain/usecases/fetch_shipment_use_case.dart';
import '../../domain/usecases/fetch_shipment_status_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/update_shipment_document_use_case.dart';
import '../../domain/usecases/create_shipment_use_case.dart';
import '../models/shipment_detail_model.dart';
import '../models/shipment_history_model.dart';
import '../models/shipment_model.dart';
import '../models/shipment_report_model.dart';

abstract interface class ShipmentRemoteDataSource {
  Future<List<ShipmentEntity>> fetchShipments(
    FetchShipmentsUseCaseParams params,
  );
  Future<String> createShipment(CreateShipmentUseCaseParams params);
  Future<String> deleteShipment(DeleteShipmentUseCaseParams params);
  Future<ShipmentDetailEntity> fetchShipment(FetchShipmentUseCaseParams params);
  Future<String> updateShipmentDocument(
    UpdateShipmentDocumentUseCaseParams params,
  );
  Future<ShipmentHistoryEntity> fetchShipmentStatus(
    FetchShipmentStatusUseCaseParams params,
  );
  Future<String> createShipmentReport(CreateShipmentReportUseCaseParams params);
  Future<String> downloadShipmentReport(
    DownloadShipmentReportUseCaseParams params,
  );
  Future<List<ShipmentReportEntity>> fetchShipmentReports(
    FetchShipmentReportsUseCaseParams params,
  );
}

class ShipmentRemoteDataSourceImpl
    with DioHandlerMixin
    implements ShipmentRemoteDataSource {
  const ShipmentRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<ShipmentEntity>> fetchShipments(
    FetchShipmentsUseCaseParams params,
  ) async {
    return await handleDioRequest<List<ShipmentEntity>>(() async {
      final response = await dio.get(
        '/shipment',
        queryParameters: {
          'date': params.date.toYMD,
          'stage': params.stage,
          'search': params.search.query,
          'page': params.paginate.page,
          'limit': params.paginate.limit,
        },
      );

      final contents = List.from(response.data['data']['content']);

      return contents.map((e) => ShipmentModel.fromJson(e).toEntity()).toList();
    });
  }

  @override
  Future<String> createShipment(CreateShipmentUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post(
        '/shipment',
        data: {'receipt_number': params.receiptNumber, 'stage': params.stage},
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> deleteShipment(DeleteShipmentUseCaseParams params) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.delete('/shipment/${params.shipmentId}');

      return response.data['message'];
    });
  }

  @override
  Future<ShipmentDetailEntity> fetchShipment(
    FetchShipmentUseCaseParams params,
  ) async {
    return await handleDioRequest<ShipmentDetailEntity>(() async {
      final response = await dio.get('/shipment/${params.shipmentId}');

      return ShipmentDetailModel.fromJson(response.data['data']).toEntity();
    });
  }

  @override
  Future<String> updateShipmentDocument(
    UpdateShipmentDocumentUseCaseParams params,
  ) async {
    return await handleDioRequest<String>(() async {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(params.documentPath),
        'stage': params.stage,
      });

      final response = await dio.post(
        '/shipment/${params.shipmentId}/document',
        data: formData,
      );

      return response.data['message'];
    });
  }

  @override
  Future<ShipmentHistoryEntity> fetchShipmentStatus(
    FetchShipmentStatusUseCaseParams params,
  ) async {
    return await handleDioRequest<ShipmentHistoryEntity>(() async {
      final response = await dio.get(
        '/shipment/status/${params.receiptNumber}',
      );

      return ShipmentHistoryModel.fromJson(response.data['data']).toEntity();
    });
  }

  @override
  Future<String> createShipmentReport(
    CreateShipmentReportUseCaseParams params,
  ) async {
    return await handleDioRequest<String>(() async {
      final response = await dio.post(
        '/shipment/report',
        data: {
          'start_date': params.startDate.toYMD,
          'end_date': params.endDate.toYMD,
        },
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> downloadShipmentReport(
    DownloadShipmentReportUseCaseParams params,
  ) async {
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
  Future<List<ShipmentReportEntity>> fetchShipmentReports(
    FetchShipmentReportsUseCaseParams params,
  ) async {
    return await handleDioRequest<List<ShipmentReportEntity>>(() async {
      final response = await dio.get(
        '/shipment/report',
        queryParameters: {
          'start_date': params.startDate.toYMD,
          'end_date': params.endDate.toYMD,
          'status': params.status,
          'page': params.paginate.page,
          'limit': params.paginate.limit,
        },
      );

      final contents = List.from(response.data['data']['content']);

      return contents
          .map((e) => ShipmentReportModel.fromJson(e).toEntity())
          .toList();
    });
  }
}
