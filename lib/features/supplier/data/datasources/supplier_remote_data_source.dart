import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/helpers/helpers.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/insert_supplier_use_case.dart';
import '../models/supplier_detail_model.dart';
import '../models/supplier_model.dart';

abstract class SupplierRemoteDataSource {
  Future<SupplierDetailModel> fetchSupplier({required String supplierId});
  Future<List<SupplierModel>> fetchSuppliers(
      {required FetchSuppliersUseCaseParams params});
  Future<List<DropdownEntity>> fetchSuppliersDropdown(
      {required FetchSuppliersDropdownUseCaseParams params});
  Future<String> insertSupplier({required InsertSupplierUseCaseParams params});
  Future<String> updateSupplier({required SupplierDetailEntity params});
}

class SupplierRemoteDataSourceImpl implements SupplierRemoteDataSource {
  SupplierRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<SupplierDetailModel> fetchSupplier(
      {required String supplierId}) async {
    try {
      final response = await dio.get('v1/supplier/$supplierId');

      return SupplierDetailModel.fromJson(response.data['data']);
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<SupplierModel>> fetchSuppliers(
      {required FetchSuppliersUseCaseParams params}) async {
    try {
      final response = await dio.get(
        'v1/supplier',
        queryParameters: {
          'column': params.column,
          'order': params.sort,
          'search': params.search,
          'limit': params.limit,
          'page': params.page,
        },
      );
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return contents.map(SupplierModel.fromJson).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<DropdownEntity>> fetchSuppliersDropdown(
      {required FetchSuppliersDropdownUseCaseParams params}) async {
    try {
      final response = await dio.get(
        'v1/supplier/dropdown',
        queryParameters: {
          'search': params.search,
          'limit': params.limit,
          'page': params.page,
        },
      );
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['content']);

      return contents.map(DropdownEntity.fromJson).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> insertSupplier(
      {required InsertSupplierUseCaseParams params}) async {
    try {
      final response = await dio.post(
        'v1/supplier',
        data: FormData.fromMap({
          'address': params.address,
          'avatar': params.avatar != null
              ? await MultipartFile.fromFile(params.avatar!)
              : null,
          'email': params.email,
          'name': params.name,
          'phoneNumber': params.phoneNumber,
        }),
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> updateSupplier({required SupplierDetailEntity params}) async {
    final supplierDetail = SupplierDetailModel.fromEntity(params);
    final payload = supplierDetail.toJson();
    final isAvatarNull = supplierDetail.avatarUrl != null;
    if (isAvatarNull &&
        !(supplierDetail.avatarUrl?.startsWith('https://') ?? false)) {
      payload['avatar'] =
          await MultipartFile.fromFile(supplierDetail.avatarUrl!);
    }

    try {
      final response = await dio.put(
        'v1/supplier/${params.id}',
        data: FormData.fromMap(payload),
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
