import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repositories.dart';

class InsertShipmentUseCase
    implements AsyncUseCaseParams<String, InsertShipmentParams> {
  const InsertShipmentUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(InsertShipmentParams params) async {
    return await shipmentRepositories.insertShipment(
        receiptNumber: params.receiptNumber, stage: params.stage);
  }
}

class InsertShipmentParams {
  const InsertShipmentParams({
    required this.receiptNumber,
    required this.stage,
  });
  final String receiptNumber;
  final String stage;
}
