import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/supplier_entity.dart';
import '../repositories/supplier_repository.dart';

class FetchSuppliersUseCase
    implements UseCase<List<SupplierEntity>, FetchSuppliersUseCaseParams> {
  const FetchSuppliersUseCase({required this.supplierRepository});

  final SupplierRepository supplierRepository;

  @override
  Future<Either<Failure, List<SupplierEntity>>> execute(
    FetchSuppliersUseCaseParams params,
  ) async {
    return await supplierRepository.fetchSuppliers(params);
  }
}

class FetchSuppliersUseCaseParams extends Equatable {
  const FetchSuppliersUseCaseParams({
    this.column = 'name',
    this.sort = 'asc',
    this.paginate = const PaginateParams(),
    this.search = const SearchParams(),
  });

  final String column;
  final String sort;
  final PaginateParams paginate;
  final SearchParams search;

  @override
  List<Object?> get props => [column, sort, paginate, search];
}
