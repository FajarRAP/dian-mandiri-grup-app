import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repositories.dart';

class CreateShipmentReportUseCase
    implements AsyncUseCaseParams<String, CreateShipmentReportParams> {
  const CreateShipmentReportUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(
      CreateShipmentReportParams params) async {
    return await shipmentRepositories.createShipmentReport(
        startDate: params.startDate, endDate: params.endDate);
  }
}

class CreateShipmentReportParams {
  const CreateShipmentReportParams({
    required this.startDate,
    required this.endDate,
  });

  final String startDate;
  final String endDate;
}
