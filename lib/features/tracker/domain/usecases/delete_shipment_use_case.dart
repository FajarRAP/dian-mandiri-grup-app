import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class DeleteShipmentUseCase implements AsyncUseCaseParams<String, String> {
  const DeleteShipmentUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await shipmentRepository.deleteShipment(shipmentId: params);
  }
}
