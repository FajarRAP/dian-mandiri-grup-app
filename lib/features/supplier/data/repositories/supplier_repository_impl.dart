import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../../domain/usecases/fetch_supplier_use_case.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/insert_supplier_use_case.dart';
import '../../domain/usecases/update_supplier_use_case.dart';
import '../datasources/supplier_remote_data_source.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  const SupplierRepositoryImpl({required this.supplierRemoteDataSource});

  final SupplierRemoteDataSource supplierRemoteDataSource;

  @override
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      FetchSupplierUseCaseParams params) async {
    try {
      final result = await supplierRemoteDataSource.fetchSupplier(
          supplierId: params.supplierId);

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
      FetchSuppliersUseCaseParams params) async {
    try {
      final result =
          await supplierRemoteDataSource.fetchSuppliers(params: params);

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
      FetchSuppliersDropdownUseCaseParams params) async {
    try {
      final result =
          await supplierRemoteDataSource.fetchSuppliersDropdown(params: params);

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
      InsertSupplierUseCaseParams params) async {
    try {
      final result =
          await supplierRemoteDataSource.insertSupplier(params: params);

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
      UpdateSupplierUseCaseParams params) async {
    try {
      final result = await supplierRemoteDataSource.updateSupplier(
          params: params.supplierDetailEntity);

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
