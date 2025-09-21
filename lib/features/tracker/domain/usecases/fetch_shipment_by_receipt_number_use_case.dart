import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_history_entity.dart';
import '../repositories/shipment_repositories.dart';

class FetchShipmentByReceiptNumberUseCase
    implements UseCase<ShipmentHistoryEntity, String> {
  const FetchShipmentByReceiptNumberUseCase(
      {required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, ShipmentHistoryEntity>> call(String params) async {
    return await shipmentRepositories.fetchShipmentByReceiptNumber(
        receiptNumber: params);
  }
}
