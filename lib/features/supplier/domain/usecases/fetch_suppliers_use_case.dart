import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_entity.dart';
import '../repositories/supplier_repositories.dart';

class FetchSuppliersUseCase
    implements AsyncUseCaseParams<List<SupplierEntity>, Map<String, dynamic>> {
  const FetchSuppliersUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, List<SupplierEntity>>> call(
      Map<String, dynamic> params) async {
    return supplierRepositories.fetchSuppliers(
      column: params['column'] ?? 'name',
      order: params['order'] ?? 'asc',
      search: params['search'],
      limit: params['limit'] ?? 10,
      page: params['page'] ?? 1,
    );
  }
}
