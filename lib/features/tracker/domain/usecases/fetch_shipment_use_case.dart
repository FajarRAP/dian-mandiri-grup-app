import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/shipment_detail_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentUseCase
    implements UseCase<ShipmentDetailEntity, FetchShipmentUseCaseParams> {
  const FetchShipmentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, ShipmentDetailEntity>> execute(
    FetchShipmentUseCaseParams params,
  ) async {
    return await shipmentRepository.fetchShipment(params);
  }
}

class FetchShipmentUseCaseParams extends Equatable {
  const FetchShipmentUseCaseParams({required this.shipmentId});

  final String shipmentId;

  @override
  List<Object?> get props => [shipmentId];
}
