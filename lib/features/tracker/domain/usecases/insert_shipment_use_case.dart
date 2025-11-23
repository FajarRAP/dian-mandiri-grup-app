import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class InsertShipmentUseCase
    implements UseCase<String, InsertShipmentUseCaseParams> {
  const InsertShipmentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> call(
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
