import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/shipment_detail_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentByIdUseCase
    implements UseCase<ShipmentDetailEntity, FetchShipmentByIdUseCaseParams> {
  const FetchShipmentByIdUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, ShipmentDetailEntity>> execute(
      FetchShipmentByIdUseCaseParams params) async {
    return await shipmentRepository.fetchShipmentById(params);
  }
}

class FetchShipmentByIdUseCaseParams extends Equatable {
  const FetchShipmentByIdUseCaseParams({required this.shipmentId});

  final String shipmentId;

  @override
  List<Object?> get props => [shipmentId];
}
