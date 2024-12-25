import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class InsertShipmentDocumentUseCase
    implements AsyncUseCaseParams<String, InsertShipmentDocumentParams> {
  final ShipmentRepository shipmentRepository;

  const InsertShipmentDocumentUseCase({required this.shipmentRepository});
  @override
  Future<Either<Failure, String>> call(
      InsertShipmentDocumentParams params) async {
    return await shipmentRepository.insertShipmentDocument(
        shipmentId: params.shipmentId,
        document: params.document,
        stage: params.stage);
  }
}

class InsertShipmentDocumentParams {
  const InsertShipmentDocumentParams({
    required this.shipmentId,
    required this.document,
    required this.stage,
  });

  final String shipmentId;
  final XFile document;
  final String stage;
}
