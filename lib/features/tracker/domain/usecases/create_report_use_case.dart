import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../repositories/ship_repositories.dart';

class CreateReportUseCase {
  final ShipRepositories shipRepo;

  CreateReportUseCase({required this.shipRepo});

  Future<Either<Failure, String>> call(DateTime date) async => await shipRepo.createReport(date);
}
