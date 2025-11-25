import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/shipment_repository.dart';

class DeleteShipmentUseCase
    implements UseCase<String, DeleteShipmentUseCaseParams> {
  const DeleteShipmentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> execute(
      DeleteShipmentUseCaseParams params) async {
    return await shipmentRepository.deleteShipment(params);
  }
}

class DeleteShipmentUseCaseParams extends Equatable {
  const DeleteShipmentUseCaseParams({
    required this.shipmentId,
  });

  final String shipmentId;

  @override
  List<Object?> get props => [shipmentId];
}
