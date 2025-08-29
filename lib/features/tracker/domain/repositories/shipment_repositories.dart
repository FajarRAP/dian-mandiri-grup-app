import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/shipment_detail_entity.dart';
import '../entities/shipment_entity.dart';
import '../entities/shipment_report_entity.dart';

abstract class ShipmentRepositories {
  Future<Either<Failure, List<ShipmentEntity>>> fetchShipments(
      {required String date,
      required String stage,
      int page = 1,
      String? keyword});
  Future<Either<Failure, String>> insertShipment(
      {required String receiptNumber, required String stage});
  Future<Either<Failure, List<ShipmentReportEntity>>> fetchShipmentReports(
      {required String startDate,
      required String endDate,
      required String status});
  Future<Either<Failure, String>> createShipmentReport(
      {required String startDate, required String endDate});
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentByReceiptNumber(
      {required String receiptNumber});
  Future<Either<Failure, ShipmentDetailEntity>> fetchShipmentById(
      {required String shipmentId});
  Future<Either<Failure, String>> deleteShipment({required String shipmentId});
  Future<Either<Failure, String>> insertShipmentDocument(
      {required String shipmentId,
      required String documentPath,
      required String stage});
  Future<Either<Failure, String>> downloadShipmentReport(
      {required ShipmentReportEntity shipmentReportEntity});
}
