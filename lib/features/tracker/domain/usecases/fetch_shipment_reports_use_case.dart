import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_report_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentReportsUseCase
    implements
        AsyncUseCaseParams<List<ShipmentReportEntity>,
            FetchShipmentReportsParams> {
  const FetchShipmentReportsUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> call(
      FetchShipmentReportsParams params) async {
    return await shipmentRepository.fetchShipmentReports(
        startDate: params.startDate,
        endDate: params.endDate,
        status: params.status);
  }
}

class FetchShipmentReportsParams {
  const FetchShipmentReportsParams({
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  final String startDate;
  final String endDate;
  final String status;
}
