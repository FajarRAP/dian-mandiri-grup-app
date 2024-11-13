import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/ship_repositories.dart';

class DeleteShipUseCase {
  final ShipRepositories shipRepo;

  DeleteShipUseCase({required this.shipRepo});

  Future<Either<Failure, String>> call(int shipId) => shipRepo.deleteShip(shipId);
}