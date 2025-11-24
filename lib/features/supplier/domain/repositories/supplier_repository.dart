import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../entities/supplier_detail_entity.dart';
import '../entities/supplier_entity.dart';
import '../usecases/fetch_supplier_use_case.dart';
import '../usecases/fetch_suppliers_dropdown_use_case.dart';
import '../usecases/fetch_suppliers_use_case.dart';
import '../usecases/insert_supplier_use_case.dart';
import '../usecases/update_supplier_use_case.dart';

abstract interface class SupplierRepository {
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      FetchSupplierUseCaseParams params);
  Future<Either<Failure, List<SupplierEntity>>> fetchSuppliers(
      FetchSuppliersUseCaseParams params);
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
      FetchSuppliersDropdownUseCaseParams params);
  Future<Either<Failure, String>> insertSupplier(
      InsertSupplierUseCaseParams params);
  Future<Either<Failure, String>> updateSupplier(
      UpdateSupplierUseCaseParams params);
}
