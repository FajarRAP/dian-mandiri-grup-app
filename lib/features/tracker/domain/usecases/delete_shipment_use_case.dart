import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repositories.dart';

class DeleteShipmentUseCase implements AsyncUseCaseParams<String, String> {
  const DeleteShipmentUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await shipmentRepositories.deleteShipment(shipmentId: params);
  }
}
