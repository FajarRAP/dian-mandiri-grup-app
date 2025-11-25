import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/shipment_repository.dart';

class CreateShipmentUseCase
    implements UseCase<String, CreateShipmentUseCaseParams> {
  const CreateShipmentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> execute(
    CreateShipmentUseCaseParams params,
  ) async {
    return await shipmentRepository.insertShipment(params);
  }
}

class CreateShipmentUseCaseParams extends Equatable {
  const CreateShipmentUseCaseParams({
    required this.receiptNumber,
    required this.stage,
  });

  final String receiptNumber;
  final String stage;

  @override
  List<Object?> get props => [receiptNumber, stage];
}
