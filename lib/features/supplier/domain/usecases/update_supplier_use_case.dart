import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/supplier_repository.dart';

class UpdateSupplierUseCase
    implements UseCase<String, UpdateSupplierUseCaseParams> {
  const UpdateSupplierUseCase({required this.supplierRepository});

  final SupplierRepository supplierRepository;

  @override
  Future<Either<Failure, String>> execute(
    UpdateSupplierUseCaseParams params,
  ) async {
    return await supplierRepository.updateSupplier(params);
  }
}

class UpdateSupplierUseCaseParams extends Equatable {
  const UpdateSupplierUseCaseParams({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.address,
    this.avatar,
    this.email,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String? address;
  final String? avatar;
  final String? email;

  @override
  List<Object?> get props => [id, name, phoneNumber, address, avatar, email];
}
