import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/shipment_history_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentStatusUseCase
    implements
        UseCase<ShipmentHistoryEntity, FetchShipmentStatusUseCaseParams> {
  const FetchShipmentStatusUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, ShipmentHistoryEntity>> execute(
    FetchShipmentStatusUseCaseParams params,
  ) async {
    return await shipmentRepository.fetchShipmentStatus(params);
  }
}

class FetchShipmentStatusUseCaseParams extends Equatable {
  const FetchShipmentStatusUseCaseParams({required this.receiptNumber});

  final String receiptNumber;

  @override
  List<Object?> get props => [receiptNumber];
}
