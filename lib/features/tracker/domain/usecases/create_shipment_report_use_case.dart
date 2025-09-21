import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repositories.dart';

class CreateShipmentReportUseCase
    implements AsyncUseCaseParams<String, CreateShipmentReportUseCaseParams> {
  const CreateShipmentReportUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(
      CreateShipmentReportUseCaseParams params) async {
    return await shipmentRepositories.createShipmentReport(params: params);
  }
}

class CreateShipmentReportUseCaseParams {
  const CreateShipmentReportUseCaseParams({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
}
