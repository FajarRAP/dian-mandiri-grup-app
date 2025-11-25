import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/shipment_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentsUseCase
    implements UseCase<List<ShipmentEntity>, FetchShipmentsUseCaseParams> {
  const FetchShipmentsUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, List<ShipmentEntity>>> execute(
      FetchShipmentsUseCaseParams params) async {
    return shipmentRepository.fetchShipments(params);
  }
}

class FetchShipmentsUseCaseParams extends Equatable {
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

  @override
  List<Object?> get props => [stage, keyword, page, date];
}
