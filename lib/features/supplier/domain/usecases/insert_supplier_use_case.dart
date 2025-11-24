import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/supplier_repositories.dart';

class InsertSupplierUseCase
    implements UseCase<String, InsertSupplierUseCaseParams> {
  const InsertSupplierUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, String>> execute(
      InsertSupplierUseCaseParams params) async {
    return await supplierRepositories.insertSupplier(params);
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
