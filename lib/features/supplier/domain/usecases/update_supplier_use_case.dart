import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/supplier_detail_entity.dart';
import '../repositories/supplier_repository.dart';

class UpdateSupplierUseCase
    implements UseCase<String, UpdateSupplierUseCaseParams> {
  const UpdateSupplierUseCase({required this.supplierRepository});

  final SupplierRepository supplierRepository;

  @override
  Future<Either<Failure, String>> execute(
      UpdateSupplierUseCaseParams params) async {
    return await supplierRepository.updateSupplier(params);
  }
}

class UpdateSupplierUseCaseParams extends Equatable {
  const UpdateSupplierUseCaseParams({required this.supplierDetailEntity});

  final SupplierDetailEntity supplierDetailEntity;

  @override
  List<Object?> get props => [supplierDetailEntity];
}
