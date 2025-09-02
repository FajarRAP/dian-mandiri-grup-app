import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repositories.dart';

class InsertShipmentUseCase
    implements AsyncUseCaseParams<String, InsertShipmentUseCaseParams> {
  const InsertShipmentUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(
      InsertShipmentUseCaseParams params) async {
    return await shipmentRepositories.insertShipment(params: params);
  }
}

class InsertShipmentUseCaseParams {
  const InsertShipmentUseCaseParams({
    required this.receiptNumber,
    required this.stage,
  });
  final String receiptNumber;
  final String stage;
}
