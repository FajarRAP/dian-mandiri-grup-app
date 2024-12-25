import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class InsertShipmentUseCase
    implements AsyncUseCaseParams<String, InsertShipmentParams> {
  const InsertShipmentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> call(InsertShipmentParams params) async {
    return await shipmentRepository.insertShipment(
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
