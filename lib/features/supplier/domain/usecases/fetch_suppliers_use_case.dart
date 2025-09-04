import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_entity.dart';
import '../repositories/supplier_repositories.dart';

class FetchSuppliersUseCase
    implements UseCase<List<SupplierEntity>, FetchSuppliersUseCaseParams> {
  const FetchSuppliersUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, List<SupplierEntity>>> call(
      FetchSuppliersUseCaseParams params) async {
    return supplierRepositories.fetchSuppliers(params: params);
  }
}

final class FetchSuppliersUseCaseParams {
  const FetchSuppliersUseCaseParams({
    this.column = 'name',
    this.sort = 'asc',
    this.search,
    this.limit = 10,
    this.page = 1,
  });

  final String column;
  final String sort;
  final String? search;
  final int limit;
  final int page;
}
