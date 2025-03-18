import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentsUseCase {
  const FetchShipmentsUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  Future<Either<Failure, Map<String, dynamic>>> call(
      FetchShipmentsParams params) async {
    return await shipmentRepository.fetchShipments(
        date: params.date,
        stage: params.stage,
        page: params.page,
        keyword: params.keyword);
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
