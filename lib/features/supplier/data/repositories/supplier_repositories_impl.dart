import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/repositories/supplier_repositories.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../datasources/supplier_remote_data_sources.dart';
import '../models/supplier_detail_model.dart';
import '../models/supplier_model.dart';

class SupplierRepositoriesImpl extends SupplierRepositories {
  SupplierRepositoriesImpl({required this.supplierRemoteDataSources});

  final SupplierRemoteDataSources<Response> supplierRemoteDataSources;

  @override
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      {required String supplierId}) async {
    try {
      final response =
          await supplierRemoteDataSources.fetchSupplier(supplierId: supplierId);
      final data = Map<String, dynamic>.from(response.data['data']);

      return Right(SupplierDetailModel.fromJson(data));
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<SupplierEntity>>> fetchSuppliers(
      {required FetchSuppliersUseCaseParams params}) async {
    try {
      final response =
          await supplierRemoteDataSources.fetchSuppliers(params: params);
      final datas =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(datas.map(SupplierModel.fromJson).toList());
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
      {required FetchSuppliersDropdownUseCaseParams params}) async {
    try {
      final response = await supplierRemoteDataSources.fetchSuppliersDropdown(
          params: params);
      final datas =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(datas.map(DropdownEntity.fromJson).toList());
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    try {
      final response = await supplierRemoteDataSources.insertSupplier(
          params: supplierDetailEntity);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return const Left(Failure());
      }
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    try {
      final response = await supplierRemoteDataSources.updateSupplier(
          params: supplierDetailEntity);

      return Right(response.data['message']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        case 400:
          return Left(Failure(message: de.response?.data['message']));
        default:
          return const Left(Failure());
      }
    } catch (e) {
      return const Left(Failure());
    }
  }
}
