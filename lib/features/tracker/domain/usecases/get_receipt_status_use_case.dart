import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/ship_entity.dart';
import '../repositories/ship_repositories.dart';

class GetReceiptStatusUseCase {
  final ShipRepositories shipRepo;

  const GetReceiptStatusUseCase({required this.shipRepo});

  Future<Either<Failure, ShipEntity>> call(String receiptNumber) async =>
      await shipRepo.getReceiptStatus(receiptNumber);
}
