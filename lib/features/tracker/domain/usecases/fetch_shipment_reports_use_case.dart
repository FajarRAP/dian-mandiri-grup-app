import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_report_entity.dart';
import '../repositories/shipment_repositories.dart';

class FetchShipmentReportsUseCase
    implements
        UseCase<List<ShipmentReportEntity>, FetchShipmentReportsUseCaseParams> {
  const FetchShipmentReportsUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> call(
      FetchShipmentReportsUseCaseParams params) async {
    return await shipmentRepositories.fetchShipmentReports(params: params);
  }
}

class FetchShipmentReportsUseCaseParams {
  const FetchShipmentReportsUseCaseParams({
    required this.page,
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  final int page;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
}
