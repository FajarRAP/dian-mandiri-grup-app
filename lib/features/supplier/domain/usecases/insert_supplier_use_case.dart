import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/supplier_repository.dart';

class InsertSupplierUseCase
    implements UseCase<String, InsertSupplierUseCaseParams> {
  const InsertSupplierUseCase({required this.supplierRepository});

  final SupplierRepository supplierRepository;

  @override
  Future<Either<Failure, String>> execute(
    InsertSupplierUseCaseParams params,
  ) async {
    return await supplierRepository.insertSupplier(params);
  }
}

class InsertSupplierUseCaseParams extends Equatable {
  const InsertSupplierUseCaseParams({
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
