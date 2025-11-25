import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/shipment_repository.dart';

class InsertShipmentDocumentUseCase
    implements UseCase<String, InsertShipmentDocumentUseCaseParams> {
  const InsertShipmentDocumentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> execute(
      InsertShipmentDocumentUseCaseParams params) async {
    return await shipmentRepository.insertShipmentDocument(params);
  }
}

class InsertShipmentDocumentUseCaseParams extends Equatable {
  const InsertShipmentDocumentUseCaseParams({
    required this.shipmentId,
    required this.documentPath,
    required this.stage,
  });

  final String shipmentId;
  final String documentPath;
  final String stage;

  @override
  List<Object?> get props => [shipmentId, documentPath, stage];
}
