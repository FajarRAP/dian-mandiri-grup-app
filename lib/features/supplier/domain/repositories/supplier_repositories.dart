import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_detail_entity.dart';
import '../entities/supplier_entity.dart';

abstract class SupplierRepositories {
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      {required String supplierId});
  Future<Either<Failure, List<SupplierEntity>>> fetchSuppliers({
    String column = 'name',
    String order = 'asc',
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown({
    String? search,
    int limit = 10,
    int page = 1,
  });
  Future<Either<Failure, String>> insertSupplier(
      {required SupplierDetailEntity supplierDetailEntity});
  Future<Either<Failure, String>> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity});
}
