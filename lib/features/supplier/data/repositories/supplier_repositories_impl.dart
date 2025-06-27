import 'dart:convert';

import 'package:dartz/dartz.dart';

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

  final SupplierRemoteDataSources supplierRemoteDataSources;

  @override
  Future<Either<Failure, SupplierDetailEntity>> fetchSupplier(
      {required String supplierId}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response =
          await supplierRemoteDataSources.fetchSupplier(supplierId: supplierId);
      final data = Map<String, dynamic>.from(jsonDecode(response));

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
      await Future.delayed(const Duration(milliseconds: 1800));
      final response = await supplierRemoteDataSources.fetchSuppliers();
      final datas = List<Map<String, dynamic>>.from(jsonDecode(response));

      return Right(datas.map(SupplierModel.fromJson).toList());
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<DropdownEntity>>> fetchSuppliersDropdown(
      {String? search, int limit = 10, int page = 1}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final response = await supplierRemoteDataSources.fetchSuppliersDropdown();
      final datas = List<Map<String, dynamic>>.from(jsonDecode(response));

      return Right(datas.map(DropdownEntity.fromJson).toList());
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final supplierDetail =
          SupplierDetailModel.fromEntity(supplierDetailEntity);
      final payload = supplierDetail.toJsonWithAvatar();
      final response =
          await supplierRemoteDataSources.insertSupplier(data: payload);
      final data = Map<String, dynamic>.from(jsonDecode(response));

      return Right(data['message']);
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1800));
      final supplierDetail =
          SupplierDetailModel.fromEntity(supplierDetailEntity);
      final payload = supplierDetail.avatarUrl.startsWith('https://')
          ? supplierDetail.toJsonWithoutAvatar()
          : supplierDetail.toJsonWithAvatar();
      final response =
          await supplierRemoteDataSources.updateSupplier(data: payload);
      final data = Map<String, dynamic>.from(jsonDecode(response));

      return Right(data['message']);
    } catch (e) {
      return const Left(Failure());
    }
  }
}
