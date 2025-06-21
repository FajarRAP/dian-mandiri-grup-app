import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_detail_entity.dart';
import '../repositories/supplier_repositories.dart';

class InsertSupplierUseCase
    implements AsyncUseCaseParams<SupplierDetailEntity, SupplierDetailEntity> {
  const InsertSupplierUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, SupplierDetailEntity>> call(
      SupplierDetailEntity params) async {
    return supplierRepositories.insertSupplier(supplierDetailEntity: params);
  }
}
