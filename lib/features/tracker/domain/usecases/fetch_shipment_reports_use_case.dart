import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/shipment_report_entity.dart';
import '../repositories/shipment_repository.dart';

class FetchShipmentReportsUseCase
    implements
        UseCase<List<ShipmentReportEntity>, FetchShipmentReportsUseCaseParams> {
  const FetchShipmentReportsUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, List<ShipmentReportEntity>>> execute(
      FetchShipmentReportsUseCaseParams params) async {
    return await shipmentRepository.fetchShipmentReports(params);
  }
}

class FetchShipmentReportsUseCaseParams extends Equatable {
  const FetchShipmentReportsUseCaseParams({
    this.paginate = const PaginateParams(),
    required this.status,
    required this.startDate,
    required this.endDate,
  });

  final PaginateParams paginate;
  final String status;
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [paginate, status, startDate, endDate];
}
