import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/supplier_repositories.dart';

class InsertSupplierUseCase
    implements AsyncUseCaseParams<String, InsertSupplierUseCaseParams> {
  const InsertSupplierUseCase({required this.supplierRepositories});

  final SupplierRepositories supplierRepositories;

  @override
  Future<Either<Failure, String>> call(
      InsertSupplierUseCaseParams params) async {
    return supplierRepositories.insertSupplier(params: params);
  }
}

final class InsertSupplierUseCaseParams {
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
}
