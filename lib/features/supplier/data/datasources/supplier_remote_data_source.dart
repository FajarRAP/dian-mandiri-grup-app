import 'package:dio/dio.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/network/dio_handler_mixin.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/usecases/fetch_supplier_use_case.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/insert_supplier_use_case.dart';
import '../../domain/usecases/update_supplier_use_case.dart';
import '../models/supplier_detail_model.dart';
import '../models/supplier_model.dart';

abstract interface class SupplierRemoteDataSource {
  Future<SupplierDetailEntity> fetchSupplier(FetchSupplierUseCaseParams params);
  Future<List<SupplierEntity>> fetchSuppliers(
    FetchSuppliersUseCaseParams params,
  );
  Future<List<DropdownEntity>> fetchSuppliersDropdown(
    FetchSuppliersDropdownUseCaseParams params,
  );
  Future<String> insertSupplier(InsertSupplierUseCaseParams params);
  Future<String> updateSupplier(UpdateSupplierUseCaseParams params);
}

class SupplierRemoteDataSourceImpl
    with DioHandlerMixin
    implements SupplierRemoteDataSource {
  const SupplierRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<SupplierDetailEntity> fetchSupplier(
    FetchSupplierUseCaseParams params,
  ) async {
    return handleDioRequest<SupplierDetailEntity>(() async {
      final response = await dio.get('/supplier/${params.supplierId}');

      return SupplierDetailModel.fromJson(response.data['data']).toEntity();
    });
  }

  @override
  Future<List<SupplierEntity>> fetchSuppliers(
    FetchSuppliersUseCaseParams params,
  ) async {
    return handleDioRequest<List<SupplierEntity>>(() async {
      final response = await dio.get(
        '/supplier',
        queryParameters: {
          'column': params.column,
          'order': params.sort,
          'search': params.search,
          'limit': params.limit,
          'page': params.page,
        },
      );
      final contents = List<JsonMap>.from(response.data['data']['content']);

      return contents.map((e) => SupplierModel.fromJson(e).toEntity()).toList();
    });
  }

  @override
  Future<List<DropdownEntity>> fetchSuppliersDropdown(
    FetchSuppliersDropdownUseCaseParams params,
  ) async {
    return handleDioRequest<List<DropdownEntity>>(() async {
      final response = await dio.get(
        '/supplier/dropdown',
        queryParameters: {
          'search': params.search,
          'limit': params.limit,
          'page': params.page,
        },
      );
      final contents = List<JsonMap>.from(response.data['data']['content']);

      return contents.map(DropdownEntity.fromJson).toList();
    });
  }

  @override
  Future<String> insertSupplier(InsertSupplierUseCaseParams params) async {
    return handleDioRequest<String>(() async {
      final response = await dio.post(
        '/supplier',
        data: FormData.fromMap({
          'address': params.address,
          'avatar': await params.avatar.toMultipartFile(),
          'email': params.email,
          'name': params.name,
          'phoneNumber': params.phoneNumber,
        }),
      );

      return response.data['message'];
    });
  }

  @override
  Future<String> updateSupplier(UpdateSupplierUseCaseParams params) async {
    return handleDioRequest<String>(() async {
      final supplierDetail = SupplierDetailModel.fromEntity(
        params.supplierDetailEntity,
      );
      final payload = supplierDetail.toJson();
      final newAvatar = await supplierDetail.avatarUrl.toMultipartFile();

      if (newAvatar != null) {
        payload['avatar'] = newAvatar;
      }

      final response = await dio.put(
        '/supplier/${params.supplierDetailEntity.id}',
        data: FormData.fromMap(payload),
      );

      return response.data['message'];
    });
  }
}
