import 'package:dio/dio.dart';

import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../models/supplier_detail_model.dart';

abstract class SupplierRemoteDataSources<T> {
  Future<T> fetchSupplier({required String supplierId});
  Future<T> fetchSuppliers({required FetchSuppliersUseCaseParams params});
  Future<T> fetchSuppliersDropdown(
      {required FetchSuppliersDropdownUseCaseParams params});
  Future<T> insertSupplier({required SupplierDetailEntity params});
  Future<T> updateSupplier({required SupplierDetailEntity params});
}

class SupplierRemoteDataSourcesImpl
    implements SupplierRemoteDataSources<Response> {
  SupplierRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<Response> fetchSupplier({required String supplierId}) async {
    return await dio.get('v1/supplier/$supplierId');
  }

  @override
  Future<Response> fetchSuppliers(
      {required FetchSuppliersUseCaseParams params}) async {
    return await dio.get(
      'v1/supplier',
      queryParameters: {
        'column': params.column,
        'order': params.sort,
        'search': params.search,
        'limit': params.limit,
        'page': params.page,
      },
    );
  }

  @override
  Future<Response> fetchSuppliersDropdown(
      {required FetchSuppliersDropdownUseCaseParams params}) async {
    return await dio.get(
      'v1/supplier/dropdown',
      queryParameters: {
        'search': params.search,
        'limit': params.limit,
        'page': params.page,
        'show_all': true,
      },
    );
  }

  @override
  Future<Response> insertSupplier(
      {required SupplierDetailEntity params}) async {
    final supplierDetail = SupplierDetailModel.fromEntity(params);
    final payload = supplierDetail.toJson();
    payload['avatar'] = await MultipartFile.fromFile(payload['avatar']);

    return await dio.post(
      'v1/supplier',
      data: FormData.fromMap(payload),
    );
  }

  @override
  Future<Response> updateSupplier(
      {required SupplierDetailEntity params}) async {
    final supplierDetail = SupplierDetailModel.fromEntity(params);
    final payload = supplierDetail.toJson();
    if (!supplierDetail.avatarUrl.startsWith('https://')) {
      payload['avatar'] = await MultipartFile.fromFile(payload['avatar']);
    }

    return await dio.put(
      'v1/supplier/${params.id}',
      data: FormData.fromMap(payload),
    );
  }
}
