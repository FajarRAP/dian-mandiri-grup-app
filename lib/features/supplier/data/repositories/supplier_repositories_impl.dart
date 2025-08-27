import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/repositories/supplier_repositories.dart';
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
      {String column = 'name',
      String order = 'asc',
      String? search,
      int limit = 10,
      int page = 1}) async {
    try {
      final response = await supplierRemoteDataSources.fetchSuppliers(
        column: column,
        order: order,
        search: search,
        limit: limit,
        page: page,
      );
      final datas =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return Right(datas.map(SupplierModel.fromJson).toList());
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
      {String? search, int limit = 10, int page = 1}) async {
    try {
      final response = await supplierRemoteDataSources.fetchSuppliersDropdown(
        search: search,
        limit: limit,
        page: page,
      );
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
      final supplierDetail =
          SupplierDetailModel.fromEntity(supplierDetailEntity);
      final payload = supplierDetail.toJson();
      payload['avatar'] = await MultipartFile.fromFile(payload['avatar']);

      final response =
          await supplierRemoteDataSources.insertSupplier(data: payload);

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
      final supplierDetail =
          SupplierDetailModel.fromEntity(supplierDetailEntity);
      final payload = supplierDetail.toJson();
      if (!supplierDetail.avatarUrl.startsWith('https://')) {
        payload['avatar'] = await MultipartFile.fromFile(payload['avatar']);
      }

      final response =
          await supplierRemoteDataSources.updateSupplier(data: payload);

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
