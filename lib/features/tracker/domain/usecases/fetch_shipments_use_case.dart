import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentsUseCase
    implements UseCase<List<ShipmentEntity>, FetchShipmentsUseCaseParams> {
  const FetchShipmentsUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, List<ShipmentEntity>>> call(
      FetchShipmentsUseCaseParams params) async {
    return shipmentRepository.fetchShipments(params: params);
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
