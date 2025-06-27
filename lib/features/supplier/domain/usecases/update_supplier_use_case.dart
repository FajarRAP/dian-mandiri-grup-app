import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_detail_entity.dart';
import '../repositories/supplier_repositories.dart';

class UpdateSupplierUseCase
    implements AsyncUseCaseParams<String, SupplierDetailEntity> {
  const UpdateSupplierUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, String>> call(
      SupplierDetailEntity params) async {
    return supplierRepositories.updateSupplier(supplierDetailEntity: params);
  }
}
