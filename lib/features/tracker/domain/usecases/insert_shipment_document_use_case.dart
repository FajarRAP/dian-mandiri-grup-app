import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repositories.dart';

class InsertShipmentDocumentUseCase
    implements AsyncUseCaseParams<String, InsertShipmentDocumentParams> {
  const InsertShipmentDocumentUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(
      InsertShipmentDocumentParams params) async {
    return await shipmentRepositories.insertShipmentDocument(
        shipmentId: params.shipmentId,
        documentPath: params.documentPath,
        stage: params.stage);
  }
}

class InsertShipmentDocumentParams {
  const InsertShipmentDocumentParams({
    required this.shipmentId,
    required this.documentPath,
    required this.stage,
  });

  final String shipmentId;
  final String documentPath;
  final String stage;
}
