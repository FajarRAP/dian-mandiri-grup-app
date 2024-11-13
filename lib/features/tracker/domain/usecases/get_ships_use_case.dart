import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/ship_entity.dart';
import '../repositories/ship_repositories.dart';

class GetShipsUseCase {
  final ShipRepositories shipRepo;

  GetShipsUseCase({required this.shipRepo});

  Future<Either<Failure, List<ShipEntity>>> call(int stageId, DateTime date) async =>
      await shipRepo.getShips(stageId, date);
}
