import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/dropdown_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/supplier_repository.dart';

class FetchSuppliersDropdownUseCase
    implements
        UseCase<List<DropdownEntity>, FetchSuppliersDropdownUseCaseParams> {
  const FetchSuppliersDropdownUseCase({required this.supplierRepository});

  final SupplierRepository supplierRepository;

  @override
  Future<Either<Failure, List<DropdownEntity>>> execute(
    FetchSuppliersDropdownUseCaseParams params,
  ) async {
    return await supplierRepository.fetchSuppliersDropdown(params);
  }
}

class FetchSuppliersDropdownUseCaseParams extends Equatable {
  const FetchSuppliersDropdownUseCaseParams({
    this.paginate = const PaginateParams(),
    this.search = const SearchParams(),
    this.showAll = false,
  });

  final PaginateParams paginate;
  final SearchParams search;
  final bool showAll;

  @override
  List<Object?> get props => [paginate, search, showAll];
}
