import 'package:dio/dio.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../main.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/insert_shipment_document_use_case.dart';
import '../../domain/usecases/insert_shipment_use_case.dart';

abstract class ShipmentRemoteDataSources<T> {
  Future<T> createShipmentReport(
      {required CreateShipmentReportUseCaseParams params});
  Future<T> deleteShipment({required String shipmentId});
  Future<T> downloadShipmentReport(
      {required DownloadShipmentReportUseCaseParams params});
  Future<T> fetchShipmentById({required String shipmentId});
  Future<T> fetchShipmentByReceiptNumber({required String receiptNumber});
  Future<T> fetchShipmentReports(
      {required FetchShipmentReportsUseCaseParams params});
  Future<T> fetchShipments({required FetchShipmentsUseCaseParams params});
  Future<T> insertShipment({required InsertShipmentUseCaseParams params});
  Future<T> insertShipmentDocument(
      {required InsertShipmentDocumentUseCaseParams params});
}

class ShipmentRemoteDataSourcesImpl
    extends ShipmentRemoteDataSources<Response> {
  ShipmentRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<Response> createShipmentReport(
      {required CreateShipmentReportUseCaseParams params}) async {
    return await dio.post(
      '$shipmentEndpoint/report',
      data: {
        'start_date': params.startDate,
        'end_date': params.endDate,
      },
    );
  }

  @override
  Future<Response> deleteShipment({required String shipmentId}) async {
    return await dio.delete('$shipmentEndpoint/$shipmentId');
  }

  @override
  Future<Response> downloadShipmentReport(
      {required DownloadShipmentReportUseCaseParams params}) async {
    final formattedDate = dMyFormat.format(params.createdAt.toLocal());

    return await dio.download(
      params.fileUrl,
      '$externalPath/${params.filename}_$formattedDate.xlsx',
    );
  }

  @override
  Future<Response> fetchShipmentById({required String shipmentId}) async {
    return await dio.get('$shipmentEndpoint/$shipmentId');
  }

  @override
  Future<Response> fetchShipmentByReceiptNumber(
      {required String receiptNumber}) async {
    return await dio.get('$shipmentEndpoint/status/$receiptNumber');
  }

  @override
  Future<Response> fetchShipmentReports(
      {required FetchShipmentReportsUseCaseParams params}) async {
    return await dio.get('$shipmentEndpoint/report', queryParameters: {
      'start_date': params.startDate,
      'end_date': params.endDate,
      'status': params.status,
      'page': params.page,
    });
  }

  @override
  Future<Response> fetchShipments(
      {required FetchShipmentsUseCaseParams params}) async {
    return await dio.get(
      shipmentEndpoint,
      queryParameters: {
        'date': params.date,
        'stage': params.stage,
        'search': params.keyword,
        'page': params.page
      },
    );
  }

  @override
  Future<Response> insertShipment(
      {required InsertShipmentUseCaseParams params}) async {
    return await dio.post(
      shipmentEndpoint,
      data: {'receipt_number': params.receiptNumber, 'stage': params.stage},
    );
  }

  @override
  Future<Response> insertShipmentDocument(
      {required InsertShipmentDocumentUseCaseParams params}) async {
    final formData = FormData.fromMap({
      'document': await MultipartFile.fromFile(params.documentPath),
      'stage': params.stage,
    });

    return await dio.post(
      '$shipmentEndpoint/${params.shipmentId}/document',
      data: formData,
    );
  }
}
