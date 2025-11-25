import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/shipment_repository.dart';

class CreateShipmentReportUseCase
    implements UseCase<String, CreateShipmentReportUseCaseParams> {
  const CreateShipmentReportUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> execute(
      CreateShipmentReportUseCaseParams params) async {
    return await shipmentRepository.createShipmentReport(params);
  }
}

class CreateShipmentReportUseCaseParams extends Equatable {
  const CreateShipmentReportUseCaseParams({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}
