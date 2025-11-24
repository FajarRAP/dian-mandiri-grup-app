import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/supplier_repositories.dart';

class FetchSuppliersDropdownUseCase
    implements
        UseCase<List<DropdownEntity>, FetchSuppliersDropdownUseCaseParams> {
  const FetchSuppliersDropdownUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, List<DropdownEntity>>> execute(
      FetchSuppliersDropdownUseCaseParams params) async {
    return await supplierRepositories.fetchSuppliersDropdown(params);
  }
}

class FetchSuppliersDropdownUseCaseParams extends Equatable {
  const FetchSuppliersDropdownUseCaseParams({
    this.search,
    this.limit = 10,
    this.page = 1,
  });

  final String? search;
  final int limit;
  final int page;

  @override
  List<Object?> get props => [search, limit, page];
}
