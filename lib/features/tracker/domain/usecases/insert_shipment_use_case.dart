import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/shipment_repository.dart';

class InsertShipmentUseCase
    implements UseCase<String, InsertShipmentUseCaseParams> {
  const InsertShipmentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> execute(
      InsertShipmentUseCaseParams params) async {
    return await shipmentRepository.insertShipment(params);
  }
}

class InsertShipmentUseCaseParams extends Equatable {
  const InsertShipmentUseCaseParams({
    required this.receiptNumber,
    required this.stage,
  });

  final String receiptNumber;
  final String stage;

  @override
  List<Object?> get props => [receiptNumber, stage];
}
