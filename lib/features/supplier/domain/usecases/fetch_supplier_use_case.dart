import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_detail_entity.dart';
import '../repositories/supplier_repositories.dart';

class FetchSupplierUseCase implements UseCase<SupplierDetailEntity, String> {
  const FetchSupplierUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, SupplierDetailEntity>> call(String params) async {
    return supplierRepositories.fetchSupplier(supplierId: params);
  }
}
