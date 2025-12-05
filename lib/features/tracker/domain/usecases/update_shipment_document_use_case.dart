import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/shipment_repository.dart';

class UpdateShipmentDocumentUseCase
    implements UseCase<String, UpdateShipmentDocumentUseCaseParams> {
  const UpdateShipmentDocumentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> execute(
    UpdateShipmentDocumentUseCaseParams params,
  ) async {
    return await shipmentRepository.updateShipmentDocument(params);
  }
}

class UpdateShipmentDocumentUseCaseParams extends Equatable {
  const UpdateShipmentDocumentUseCaseParams({
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
