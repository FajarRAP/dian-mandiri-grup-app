import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class InsertShipmentDocumentUseCase
    implements UseCase<String, InsertShipmentDocumentUseCaseParams> {
  const InsertShipmentDocumentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> call(
      InsertShipmentDocumentUseCaseParams params) async {
    return await shipmentRepository.insertShipmentDocument(params: params);
  }
}

class InsertShipmentDocumentUseCaseParams {
  const InsertShipmentDocumentUseCaseParams({
    required this.shipmentId,
    required this.documentPath,
    required this.stage,
  });

  final String shipmentId;
  final String documentPath;
  final String stage;
}
