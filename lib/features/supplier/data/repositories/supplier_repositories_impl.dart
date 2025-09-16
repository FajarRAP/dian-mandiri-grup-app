import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/repositories/supplier_repositories.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/insert_supplier_use_case.dart';
import '../datasources/supplier_remote_data_sources.dart';

class SupplierRepositoriesImpl extends SupplierRepositories {
  SupplierRepositoriesImpl({required this.supplierRemoteDataSources});

  final SupplierRemoteDataSources supplierRemoteDataSources;

  @override
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      {required String supplierId}) async {
    try {
      final result =
          await supplierRemoteDataSources.fetchSupplier(supplierId: supplierId);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> fetchSuppliers(
      {required FetchSuppliersUseCaseParams params}) async {
    try {
      final result =
          await supplierRemoteDataSources.fetchSuppliers(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
      {required FetchSuppliersDropdownUseCaseParams params}) async {
    try {
      final result = await supplierRemoteDataSources.fetchSuppliersDropdown(
          params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> insertSupplier(
      {required InsertSupplierUseCaseParams params}) async {
    try {
      final result =
          await supplierRemoteDataSources.insertSupplier(params: params);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    try {
      final result = await supplierRemoteDataSources.updateSupplier(
          params: supplierDetailEntity);

      return Right(result);
    } on ServerException catch (se) {
      return Left(ServerFailure(
        message: se.message,
        statusCode: se.statusCode,
      ));
    } on InternalException catch (ie) {
      return Left(Failure(
        message: ie.message,
        statusCode: ie.statusCode,
      ));
    }
  }
}
