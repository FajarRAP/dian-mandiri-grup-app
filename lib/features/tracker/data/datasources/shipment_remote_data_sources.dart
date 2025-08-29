import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/helpers/helpers.dart';
import '../models/shipment_report_model.dart';

abstract class ShipmentRemoteDataSources<T> {
  Future<T> fetchShipments(
      {required String date,
      required String stage,
      required int page,
      String? keyword});
  Future<T> insertShipment(
      {required String receiptNumber, required String stage});
  Future<T> fetchShipmentReports(
      {required String startDate,
      required String endDate,
      required String status});
  Future<T> createShipmentReport(
      {required String startDate, required String endDate});
  Future<T> fetchShipmentByReceiptNumber({required String receiptNumber});
  Future<T> fetchShipmentById({required String shipmentId});
  Future<T> deleteShipment({required String shipmentId});
  Future<T> insertShipmentDocument(
      {required String shipmentId,
      required String documentPath,
      required String stage});
  Future<T> downloadShipmentReport(
      {required ShipmentReportModel shipmentReportModel});
}

class ShipmentRemoteDataSourcesImpl
    extends ShipmentRemoteDataSources<Response> {
  ShipmentRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<Response> createShipmentReport(
      {required String startDate, required String endDate}) async {
    return await dio.post('$shipmentEndpoint/report',
        data: {'start_date': startDate, 'end_date': endDate});
  }

  @override
  Future<Response> deleteShipment({required String shipmentId}) async {
    return await dio.delete('$shipmentEndpoint/$shipmentId');
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
      {required String startDate,
      required String endDate,
      required String status}) async {
    return await dio.get('$shipmentEndpoint/report', queryParameters: {
      'start_date': startDate,
      'end_date': endDate,
      'status': status
    });
  }

  @override
  Future<Response> fetchShipments(
      {required String date,
      required String stage,
      required int page,
      String? keyword}) async {
    return await dio.get(
      shipmentEndpoint,
      queryParameters: {
        'date': date,
        'stage': stage,
        'search': keyword,
        'page': page
      },
    );
  }

  @override
  Future<Response> insertShipment(
      {required String receiptNumber, required String stage}) async {
    return await dio.post(
      shipmentEndpoint,
      data: {'receipt_number': receiptNumber, 'stage': stage},
    );
  }

  @override
  Future<Response> insertShipmentDocument(
      {required String shipmentId,
      required String documentPath,
      required String stage}) async {
    final formData = FormData.fromMap({
      'document': await MultipartFile.fromFile(documentPath),
      'stage': stage,
    });

    return await dio.post(
      '$shipmentEndpoint/$shipmentId/document',
      data: formData,
    );
  }

  @override
  Future<Response> downloadShipmentReport(
      {required ShipmentReportModel shipmentReportModel}) async {
    final directory = await getExternalStorageDirectory();
    final formattedDate = timeFormat.format(shipmentReportModel.date.toLocal());

    return await dio.download(
      shipmentReportModel.file,
      '${directory?.path}/${shipmentReportModel.name}_$formattedDate.xlsx',
    );
  }
}
