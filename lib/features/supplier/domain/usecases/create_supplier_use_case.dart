import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/supplier_repository.dart';

class CreateSupplierUseCase
    implements UseCase<String, CreateSupplierUseCaseParams> {
  const CreateSupplierUseCase({required this.supplierRepository});

  final SupplierRepository supplierRepository;

  @override
  Future<Either<Failure, String>> execute(
    CreateSupplierUseCaseParams params,
  ) async {
    return await supplierRepository.createSupplier(params);
  }
}

class CreateSupplierUseCaseParams extends Equatable {
  const CreateSupplierUseCaseParams({
    this.address,
    this.avatar,
    this.email,
    required this.name,
    required this.phoneNumber,
  });

  final String? address;
  final String? avatar;
  final String? email;
  final String name;
  final String phoneNumber;

  @override
  List<Object?> get props => [address, avatar, email, name, phoneNumber];
}
