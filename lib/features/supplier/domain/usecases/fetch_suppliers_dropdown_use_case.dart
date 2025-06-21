import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/supplier_repositories.dart';

class FetchSuppliersDropdownUseCase
    implements AsyncUseCaseParams<List<DropdownEntity>, Map<String, dynamic>> {
  const FetchSuppliersDropdownUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, List<DropdownEntity>>> call(
      Map<String, dynamic> params) async {
    return supplierRepositories.fetchSuppliersDropdown(
      search: params['search'],
      limit: params['limit'] ?? 10,
      page: params['page'] ?? 1,
    );
  }
}
