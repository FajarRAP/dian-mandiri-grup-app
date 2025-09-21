import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_entity.dart';
import '../repositories/shipment_repositories.dart';

class FetchShipmentsUseCase
    implements UseCase<List<ShipmentEntity>, FetchShipmentsUseCaseParams> {
  const FetchShipmentsUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, List<ShipmentEntity>>> call(
      FetchShipmentsUseCaseParams params) async {
    return shipmentRepositories.fetchShipments(params: params);
  }
}

class FetchShipmentsUseCaseParams {
  const FetchShipmentsUseCaseParams({
    required this.stage,
    this.keyword,
    this.page = 1,
    required this.date,
  });

  final String stage;
  final String? keyword;
  final int page;
  final DateTime date;
}
