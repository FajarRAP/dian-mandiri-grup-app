import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/respository_handler_mixin.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../../domain/usecases/fetch_supplier_use_case.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/create_supplier_use_case.dart';
import '../../domain/usecases/update_supplier_use_case.dart';
import '../datasources/supplier_remote_data_source.dart';

class SupplierRepositoryImpl
    with RepositoryHandlerMixin
    implements SupplierRepository {
  const SupplierRepositoryImpl({required this.supplierRemoteDataSource});

  final SupplierRemoteDataSource supplierRemoteDataSource;

  @override
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
    FetchSupplierUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<SupplierDetailEntity>(() async {
      final result = await supplierRemoteDataSource.fetchSupplier(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> fetchSuppliers(
    FetchSuppliersUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<List<SupplierEntity>>(() async {
      final result = await supplierRemoteDataSource.fetchSuppliers(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
    FetchSuppliersDropdownUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<List<DropdownEntity>>(() async {
      final result = await supplierRemoteDataSource.fetchSuppliersDropdown(
        params,
      );

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> createSupplier(
    CreateSupplierUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await supplierRemoteDataSource.createSupplier(params);

      return result;
    });
  }

  @override
  Future<Either<Failure, String>> updateSupplier(
    UpdateSupplierUseCaseParams params,
  ) async {
    return await handleRepositoryRequest<String>(() async {
      final result = await supplierRemoteDataSource.updateSupplier(params);

      return result;
    });
  }
}
