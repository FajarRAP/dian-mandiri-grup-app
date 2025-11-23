import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_history_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentByReceiptNumberUseCase
    implements
        UseCase<ShipmentHistoryEntity,
            FetchShipmentByReceiptNumberUseCaseParams> {
  const FetchShipmentByReceiptNumberUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, ShipmentHistoryEntity>> call(
      FetchShipmentByReceiptNumberUseCaseParams params) async {
    return await shipmentRepository.fetchShipmentByReceiptNumber(params);
  }
}

class FetchShipmentByReceiptNumberUseCaseParams extends Equatable {
  const FetchShipmentByReceiptNumberUseCaseParams(
      {required this.receiptNumber});

  final String receiptNumber;

  @override
  List<Object?> get props => [receiptNumber];
}
