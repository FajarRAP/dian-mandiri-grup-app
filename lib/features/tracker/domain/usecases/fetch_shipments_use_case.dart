import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_entity.dart';
import '../repositories/shipment_repositories.dart';

class FetchShipmentsUseCase
    implements AsyncUseCaseParams<List<ShipmentEntity>, FetchShipmentsParams> {
  const FetchShipmentsUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, List<ShipmentEntity>>> call(
      FetchShipmentsParams params) async {
    return shipmentRepositories.fetchShipments(
      date: params.date,
      stage: params.stage,
      page: params.page,
      keyword: params.keyword,
    );
  }
}

class FetchShipmentsParams {
  const FetchShipmentsParams({
    required this.date,
    required this.stage,
    this.page = 1,
    this.keyword,
  });

  final String date;
  final String stage;
  final int page;
  final String? keyword;
}
