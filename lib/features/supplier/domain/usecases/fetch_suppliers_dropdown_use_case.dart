import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/supplier_repositories.dart';

class FetchSuppliersDropdownUseCase
    implements
        UseCase<List<DropdownEntity>, FetchSuppliersDropdownUseCaseParams> {
  const FetchSuppliersDropdownUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, List<DropdownEntity>>> call(
      FetchSuppliersDropdownUseCaseParams params) async {
    return supplierRepositories.fetchSuppliersDropdown(params: params);
  }
}

final class FetchSuppliersDropdownUseCaseParams {
  const FetchSuppliersDropdownUseCaseParams({
    this.search,
    this.limit = 10,
    this.page = 1,
  });

  final String? search;
  final int limit;
  final int page;
}
