import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_detail_entity.dart';
import '../repositories/supplier_repositories.dart';

class InsertSupplierUseCase
    implements AsyncUseCaseParams<String, SupplierDetailEntity> {
  const InsertSupplierUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, String>> call(SupplierDetailEntity params) async {
    return supplierRepositories.insertSupplier(supplierDetailEntity: params);
  }
}
