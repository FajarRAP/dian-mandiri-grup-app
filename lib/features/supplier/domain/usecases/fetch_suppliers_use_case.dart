import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/supplier_entity.dart';
import '../repositories/supplier_repository.dart';

class FetchSuppliersUseCase
    implements UseCase<List<SupplierEntity>, FetchSuppliersUseCaseParams> {
  const FetchSuppliersUseCase({required this.supplierRepository});

  final SupplierRepository supplierRepository;

  @override
  Future<Either<Failure, List<SupplierEntity>>> execute(
      FetchSuppliersUseCaseParams params) async {
    return await supplierRepository.fetchSuppliers(params);
  }
}

class FetchSuppliersUseCaseParams extends Equatable {
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

  @override
  List<Object?> get props => [column, sort, search, limit, page];
}
