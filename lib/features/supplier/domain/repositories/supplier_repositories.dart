import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_detail_entity.dart';
import '../entities/supplier_entity.dart';
import '../usecases/fetch_suppliers_dropdown_use_case.dart';
import '../usecases/fetch_suppliers_use_case.dart';

abstract class SupplierRepositories {
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      {required String supplierId});
  Future<Either<Failure, List<SupplierEntity>>> fetchSuppliers(
      {required FetchSuppliersUseCaseParams params});
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
      {required FetchSuppliersDropdownUseCaseParams params});
  Future<Either<Failure, String>> insertSupplier(
      {required SupplierDetailEntity supplierDetailEntity});
  Future<Either<Failure, String>> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity});
}
