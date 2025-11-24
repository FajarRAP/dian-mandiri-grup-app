import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/supplier_detail_entity.dart';
import '../repositories/supplier_repositories.dart';

class FetchSupplierUseCase
    implements UseCase<SupplierDetailEntity, FetchSupplierUseCaseParams> {
  const FetchSupplierUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, SupplierDetailEntity>> execute(
      FetchSupplierUseCaseParams params) async {
    return await supplierRepositories.fetchSupplier(params);
  }
}

class FetchSupplierUseCaseParams extends Equatable {
  const FetchSupplierUseCaseParams({required this.supplierId});

  final String supplierId;

  @override
  List<Object?> get props => [supplierId];
}
