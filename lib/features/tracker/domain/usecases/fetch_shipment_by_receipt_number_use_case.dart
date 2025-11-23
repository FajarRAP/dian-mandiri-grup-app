import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_history_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentByReceiptNumberUseCase
    implements UseCase<ShipmentHistoryEntity, String> {
  const FetchShipmentByReceiptNumberUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, ShipmentHistoryEntity>> call(String params) async {
    return await shipmentRepository.fetchShipmentByReceiptNumber(
        receiptNumber: params);
  }
}
