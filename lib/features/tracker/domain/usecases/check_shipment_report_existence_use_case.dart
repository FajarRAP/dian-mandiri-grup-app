import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/shipment_repository.dart';

class CheckShipmentReportExistenceUseCase
    implements UseCase<bool, CheckShipmentReportExistenceUseCaseParams> {
  const CheckShipmentReportExistenceUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, bool>> execute(
    CheckShipmentReportExistenceUseCaseParams params,
  ) async {
    return await shipmentRepository.checkShipmentReportExistence(params);
  }
}

class CheckShipmentReportExistenceUseCaseParams extends Equatable {
  const CheckShipmentReportExistenceUseCaseParams({required this.filename});

  final String filename;

  @override
  List<Object?> get props => [filename];
}
