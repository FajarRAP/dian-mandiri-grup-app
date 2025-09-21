import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_detail_entity.dart';
import '../repositories/shipment_repositories.dart';

class FetchShipmentByIdUseCase
    implements UseCase<ShipmentDetailEntity, String> {
  const FetchShipmentByIdUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, ShipmentDetailEntity>> call(String params) async {
    return await shipmentRepositories.fetchShipmentById(shipmentId: params);
  }
}
