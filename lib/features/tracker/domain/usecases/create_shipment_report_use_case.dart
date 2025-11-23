import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class CreateShipmentReportUseCase
    implements AsyncUseCaseParams<String, CreateShipmentReportUseCaseParams> {
  const CreateShipmentReportUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> call(
      CreateShipmentReportUseCaseParams params) async {
    return await shipmentRepository.createShipmentReport(params: params);
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
