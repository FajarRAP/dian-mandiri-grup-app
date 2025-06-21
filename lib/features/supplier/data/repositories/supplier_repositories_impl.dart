import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/repositories/supplier_repositories.dart';

class SupplierRepositoriesImpl extends SupplierRepositories {
  @override
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      {required String supplierId}) {
    // TODO: implement fetchSupplier
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> fetchSuppliers(
      {String column = 'name',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) {
    // TODO: implement fetchSuppliers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
      {String? search, int limit = 10, int page = 1}) {
    // TODO: implement fetchSuppliersDropdown
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SupplierDetailEntity>> insertSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) {
    // TODO: implement insertSupplier
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SupplierDetailEntity>> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) {
    // TODO: implement updateSupplier
    throw UnimplementedError();
  }
}
